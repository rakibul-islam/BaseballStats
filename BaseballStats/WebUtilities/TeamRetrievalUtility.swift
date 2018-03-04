//
//  TeamRetrievalUtility.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class TeamRetrievalUtility {
    let baseURL = "https://jobposting28.azurewebsites.net/api/team"
    private var teams = [Team]()
    
    static let sharedInstance = TeamRetrievalUtility()
    
    func getTeams(completionBlock: (([Team]) -> Void)?) {
        if teams.count == 0 {
            if let url = URL(string: baseURL) {
                let session = URLSession.shared
                let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let responseData = data {
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                                for teamDictionary in jsonDict {
                                    self.teams.append(Team(dictionary: teamDictionary))
                                }
                            }
                            completionBlock?(self.teams)
                        } catch let jsonError {
                            print(jsonError)
                        }
                    } else if let responseError = error {
                        print(responseError)
                    }
                })
                sessionTask.resume()
            }
        } else {
            completionBlock?(self.teams)
        }
    }
    
    func getTeamForId(teamID: Int) -> Team? {
        return teams.first(where: { (team) -> Bool in
            return team.teamID == teamID
        })
    }
    
    func getRosterFor(team: Team, completionBlock: @escaping ([Player]) -> Void, failureBlock: @escaping (Error) -> Void) {
        let urlString = "\(baseURL)/\(team.teamID)/roster"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let responseData = data {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                            var players = [Player]()
                            for playerDictionary in jsonDict {
                                players.append(Player(dictionary: playerDictionary))
                            }
                            completionBlock(players)
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
