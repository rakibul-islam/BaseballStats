//
//  PlayerRetrievalUtility.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

protocol PlayerRetrievalUtilityProtocol {
    func getPlayersWith(searchParameter: String, completionBlock: @escaping ([PlayerMO]) -> Void, failureBlock: @escaping (Error) -> Void)
    func getStats(for player: PlayerMO?, completionBlock: @escaping () -> Void, failureBlock: @escaping (Error) -> Void)
    func loadImageFrom(urlString: String?, completionHandler: @escaping (UIImage?) -> Void)
}

class PlayerRetrievalUtility: PlayerRetrievalUtilityProtocol {
    let baseURL = "https://jobposting28.azurewebsites.net/api/"
    var coreDataController = CoreDataController.sharedInstance
    
    func getPlayersWith(searchParameter: String, completionBlock: @escaping ([PlayerMO]) -> Void, failureBlock: @escaping (Error) -> Void) {
        let encodedStr = searchParameter.addingPercentEncoding(withAllowedCharacters: .letters) ?? searchParameter
        let urlString = "\(baseURL)player?criteria=\(encodedStr)"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let responseData = data {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                            var players = [PlayerMO]()
                            for playerDictionary in jsonDict {
                                if let team = self.coreDataController.getTeamFor(team: playerDictionary["TeamID"]) {
                                    self.coreDataController.addPlayerFor(team: team, with: playerDictionary)
                                } else {
                                    self.coreDataController.addPlayerFrom(dictionary: playerDictionary)
                                }
                                let player = self.coreDataController.getPlayerFor(player: playerDictionary["PlayerID"])!
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
                                }
                                if let pitchingStatsArray = jsonDict["Pitching"] as? [[String: Any]] {
                                    for pitchingStatsDict in pitchingStatsArray {
                                        self.coreDataController.addPitchingStatFor(player: playerObject, with: pitchingStatsDict)
                                    }
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
