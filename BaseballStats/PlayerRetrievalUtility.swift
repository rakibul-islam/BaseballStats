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
    func getPlayersWith(searchParameter: String, completionBlock: @escaping ([Player]) -> Void, failureBlock: @escaping (Error) -> Void) {
        let urlString = "\(baseURL)player?criteria=\(searchParameter)"
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
    
    func getStats(for player: Int?, completionBlock: @escaping ([BattingStats]) -> Void, failureBlock: @escaping (Error) -> Void) {
        if let playerID = player {
            let urlString = "\(baseURL)player/\(playerID)/stats"
            if let url = URL(string: urlString) {
                let session = URLSession.shared
                let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let responseData = data {
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                if let battingStatsArray = jsonDict["Batting"] as? [[String: Any]] {
                                    var allBattingStats = [BattingStats]()
                                    for battingStatsDict in battingStatsArray {
                                        allBattingStats.append(BattingStats(dictionary: battingStatsDict))
                                    }
                                    completionBlock(allBattingStats)
                                }
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
