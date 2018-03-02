//
//  PlayerRetrievalUtility.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/1/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class PlayerRetrievalUtility: NSObject {
    func getPlayersWith(searchParameter: String, completionBlock: @escaping ([Player]) -> Void) {
        let urlString = "https://jobposting28.azurewebsites.net/api/player?criteria=\(searchParameter)"
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
                        print(jsonError)
                    }
                } else if let responseError = error {
                    print(responseError)
                }
            })
            sessionTask.resume()
        }
    }
}
