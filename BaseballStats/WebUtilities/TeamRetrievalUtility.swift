//
//  TeamRetrievalUtility.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit

class TeamRetrievalUtility {
    static let sharedInstance = TeamRetrievalUtility()
    
    let baseURL = "https://jobposting28.azurewebsites.net/api/team"
    func getTeams(completionBlock: @escaping ([Team]) -> Void, failureBlock: @escaping (Error) -> Void) {
        if let url = URL(string: baseURL) {
            let session = URLSession.shared
            let sessionTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let responseData = data {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                            var teams = [Team]()
                            for teamDictionary in jsonDict {
                                teams.append(Team(dictionary: teamDictionary))
                            }
                            completionBlock(teams)
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
