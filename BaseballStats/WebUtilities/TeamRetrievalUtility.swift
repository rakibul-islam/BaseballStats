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
    
    func getTeams(completionBlock: (([Team]) -> Void)?, failureBlock: @escaping (Error) -> Void) {
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
    
    func getTeamForId(teamID: Int?) -> Team? {
        guard let teamId = teamID else {
            return nil
        }
        return teams.first(where: { (team) -> Bool in
            return team.teamID == teamId
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
                                let player = Player(dictionary: playerDictionary)
                                player.team = team
                                players.append(player)
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
