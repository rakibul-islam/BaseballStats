//
//  PlayerRetrievalUtility.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PlayerRetrievalUtility: NSObject {
    let baseURL = "https://jobposting28.azurewebsites.net/api/"
    var coreDataController = CoreDataController.sharedInstance
    
    func getPlayersWith(searchParameter: String, completionBlock: @escaping ([Player]) -> Void, failureBlock: @escaping (Error) -> Void) {
        let encodedStr = searchParameter.addingPercentEncoding(withAllowedCharacters: .letters) ?? searchParameter
        let urlString = "\(baseURL)player?criteria=\(encodedStr)"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let responseData = data {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                            var players = [Player]()
                            for playerDictionary in jsonDict {
                                let player = Player(dictionary: playerDictionary)
                                player.teamMO = self.coreDataController.getTeamFor(team: player.teamID)
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
    
    func getStats(for player: Int?, completionBlock: @escaping ([BattingStats], [PitchingStats]) -> Void, failureBlock: @escaping (Error) -> Void) {
        if let playerID = player {
            let urlString = "\(baseURL)player/\(playerID)/stats"
            if let url = URL(string: urlString) {
                let session = URLSession.shared
                let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let responseData = data {
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                var allBattingStats = [BattingStats]()
                                if let battingStatsArray = jsonDict["Batting"] as? [[String: Any]] {
                                    for battingStatsDict in battingStatsArray {
                                        allBattingStats.append(BattingStats(dictionary: battingStatsDict))
                                    }
                                    allBattingStats = allBattingStats.sorted(by: { (stat1, stat2) -> Bool in
                                        return stat1.yearID > stat2.yearID
                                    })
                                }
                                var allPitchingStats = [PitchingStats]()
                                if let pitchingStatsArray = jsonDict["Pitching"] as? [[String: Any]] {
                                    for pitchingStatsDict in pitchingStatsArray {
                                        allPitchingStats.append(PitchingStats(dictionary: pitchingStatsDict))
                                    }
                                    allPitchingStats = allPitchingStats.sorted(by: { (stat1, stat2) -> Bool in
                                        return stat1.yearID > stat2.yearID
                                    })
                                }
                                completionBlock(allBattingStats, allPitchingStats)
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
    
    func getStats(for player: PlayerMO?, completionBlock: @escaping () -> Void, failureBlock: @escaping (Error) -> Void) {
        if let playerObject = player {
            let urlString = "\(baseURL)player/\(playerObject.playerID)/stats"
            if let url = URL(string: urlString) {
                let session = URLSession.shared
                let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let responseData = data {
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                if let battingStatsArray = jsonDict["Batting"] as? [[String: Any]] {
                                    for battingStatsDict in battingStatsArray {
                                        self.coreDataController.addBattingStatFor(player: playerObject, with: battingStatsDict)
                                    }
                                    playerObject.battingStats = playerObject.battingStats?.reversed //Sort from most recent year first
                                }
                                if let pitchingStatsArray = jsonDict["Pitching"] as? [[String: Any]] {
                                    for pitchingStatsDict in pitchingStatsArray {
                                        self.coreDataController.addPitchingStatFor(player: playerObject, with: pitchingStatsDict)
                                    }
                                    playerObject.pitchingStats = playerObject.pitchingStats?.reversed //Sort from most recent year first
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
    
    
    func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void) {
        if let string = urlString, let url = URL(string: string) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    completionHandler(image)
                }
            })
            sessionTask.resume()
        }
    }
}
