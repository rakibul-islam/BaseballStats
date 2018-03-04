//
//  TeamRetrievalUtility.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class TeamRetrievalUtility {
    private let baseURL = "https://jobposting28.azurewebsites.net/api/team"
    private var teams = [TeamMO]()
    var coreDataController = CoreDataController.sharedInstance
    
    static let sharedInstance = TeamRetrievalUtility()
    
    func getTeams(completionBlock: (([TeamMO]) -> Void)?, failureBlock: @escaping (Error) -> Void) {
        teams = coreDataController.getAllTeams()
        if teams.count == 0 {
            if let url = URL(string: baseURL) {
                let session = URLSession.shared
                let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let responseData = data {
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                                for teamDictionary in jsonDict {
                                    self.coreDataController.addTeamFrom(dictionary: teamDictionary)
                                }
                            }
                            self.teams = self.coreDataController.getAllTeams()
                            completionBlock?(self.teams)
                        } catch let jsonError {
                            failureBlock(jsonError)
                        }
                    } else if let responseError = error {
                        failureBlock(responseError)
                    }
                })
                sessionTask.resume()
            }
        } else {
            completionBlock?(self.teams)
        }
    }
    
    func getRosterFor(team: TeamMO, completionBlock: @escaping () -> Void, failureBlock: @escaping (Error) -> Void) {
        let urlString = "\(baseURL)/\(team.teamID)/roster"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let responseData = data {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                            for playerDictionary in jsonDict {
                                self.coreDataController.addPlayerFor(team: team, with: playerDictionary)
                            }
                            completionBlock()
                        }
                    } catch let jsonError {
                        failureBlock(jsonError)
                    }
                } else if let responseError = error {
                    failureBlock(responseError)
                }
            })
            sessionTask.resume()
        }
        
    }
}
