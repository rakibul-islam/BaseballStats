//
//  CoreDataController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController {
    private var managedObjectContext: NSManagedObjectContext
    private var privateManagedObjectContext: NSManagedObjectContext
    
    static let sharedInstance = CoreDataController()
    
    init() {
        guard let modelURL = Bundle.main.url(forResource: "BaseballStats", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let optionsDict = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true), NSInferMappingModelAutomaticallyOption: NSNumber(value: true)]
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.parent = privateManagedObjectContext
        
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        let storeURL = docURL.appendingPathComponent("BaseballStats.sqlite")
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: optionsDict)
            NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveContext(notification:)), name: .NSManagedObjectContextDidSave, object: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func setupInMemoryManagedObjectContext() {
        guard let modelURL = Bundle.main.url(forResource: "BaseballStats", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            managedObjectContext.performAndWait {
                do {
                    try self.managedObjectContext.save()
                } catch {
                    fatalError("Failed to save context: \(error)")
                }
            }
        }
    }
    
    func savePrivateContext() {
        privateManagedObjectContext.perform {
            do {
                try self.privateManagedObjectContext.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
    }
    
    @objc func contextDidSaveContext(notification: Notification) {
        if managedObjectContext.isEqual(notification.object) {
            savePrivateContext()
        }
    }
    
    //MARK: - Add objects from dictionary methods
    
    func addTeamFrom(dictionary: [String: Any]) {
        let teamMO = getTeamFor(team: dictionary["TeamID"]) ?? createTeamEntity()
        teamMO.setupTeamFrom(dictionary: dictionary)
        saveContext()
    }
    
    func addPlayerFrom(dictionary: [String: Any]) {
        let playerMO = getPlayerFor(player: dictionary["PlayerID"]) ?? createPlayerEntity()
        playerMO.setupFrom(dictionary: dictionary)
        saveContext()
    }
    
    func addPlayerFor(team: TeamMO, with dictionary: [String: Any]) {
        let playerMO = getPlayerFor(player: dictionary["PlayerID"]) ?? createPlayerEntity()
        playerMO.setupFrom(dictionary: dictionary)
        playerMO.team = team
        saveContext()
    }
    
    func addBattingStatFor(player: PlayerMO, with dictionary: [String: Any]) {
        let battingStatMO = getBattingStatFor(player: player, for: dictionary["YearID"], with: dictionary["TeamID"]) ?? createBattingStatEntity()
        battingStatMO.setupBattingFrom(dictionary: dictionary)
        battingStatMO.player = player
        battingStatMO.team = getTeamFor(team: dictionary["TeamID"])
        saveContext()
    }
    
    func addPitchingStatFor(player: PlayerMO, with dictionary: [String: Any]) {
        let pitchingStatMO = getPitchingStatFor(player: player, for: dictionary["YearID"], with: dictionary["TeamID"]) ?? createPitchingStatEntity()
        pitchingStatMO.setupPitchingFrom(dictionary: dictionary)
        pitchingStatMO.player = player
        pitchingStatMO.team = getTeamFor(team: dictionary["TeamID"])
        saveContext()
    }
    
    //MARK: - Other save methods
    func bookmark(player: PlayerMO) {
        player.bookmarked = !player.bookmarked
        saveContext()
    }
    
    //MARK: - Get objects methods
    
    func getAllTeams() -> [TeamMO] {
        let teamFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        var teams = [TeamMO]()
        
        do {
            if let fetchedTeams = try managedObjectContext.fetch(teamFetchRequest) as? [TeamMO] {
                teams = fetchedTeams
            }
        } catch {
            return teams
        }
        return teams
    }
    
    func getTeamFor(team: Any?) -> TeamMO? {
        guard let teamID = team as? Int, teamID > 0 else {
            return nil
        }
        let teamFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        teamFetchRequest.predicate = NSPredicate(format: "teamID == %d", teamID)
        do {
            if let fetchResult = try managedObjectContext.fetch(teamFetchRequest) as? [TeamMO] {
                return fetchResult.last
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getPlayerFor(player: Any?) -> PlayerMO? {
        guard let playerID = player as? Int, playerID > 0 else {
            return nil
        }
        let playerFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        playerFetchRequest.predicate = NSPredicate(format: "playerID == %d", playerID)
        do {
            if let fetchResult = try managedObjectContext.fetch(playerFetchRequest) as? [PlayerMO] {
                return fetchResult.last
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getBookmarkedPlayers() -> [PlayerMO]? {
        let playerFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        playerFetchRequest.predicate = NSPredicate(format: "bookmarked == YES")
        do {
            if let fetchResult = try managedObjectContext.fetch(playerFetchRequest) as? [PlayerMO] {
                return fetchResult
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getBattingStatFor(player: PlayerMO, for year: Any?, with team: Any?) -> BattingStatMO? {
        guard let yearID = year as? Int16, let teamID = team as? Int16 else {
            return nil
        }
        let statFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BattingStat")
        statFetchRequest.predicate = NSPredicate(format: "playerID == %d AND yearID == %d AND teamID == %d", player.playerID, yearID, teamID)
        do {
            if let fetchResult = try managedObjectContext.fetch(statFetchRequest) as? [BattingStatMO] {
                return fetchResult.last
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func getPitchingStatFor(player: PlayerMO, for year: Any?, with team: Any?) -> PitchingStatMO? {
        guard let yearID = year as? Int16, let teamID = team as? Int16 else {
            return nil
        }
        let statFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PitchingStat")
        statFetchRequest.predicate = NSPredicate(format: "playerID == %d AND yearID == %d AND teamID == %d", player.playerID, yearID, teamID)
        do {
            if let fetchResult = try managedObjectContext.fetch(statFetchRequest) as? [PitchingStatMO] {
                return fetchResult.last
            }
        } catch {
            return nil
        }
        return nil
    }
    
    //MARK: - Create entity methods
    
    func createTeamEntity() -> TeamMO {
        return NSEntityDescription.insertNewObject(forEntityName: "Team", into: self.managedObjectContext) as! TeamMO
    }
    
    func createPlayerEntity() -> PlayerMO {
        return NSEntityDescription.insertNewObject(forEntityName: "Player", into: self.managedObjectContext) as! PlayerMO
    }
    
    func createBattingStatEntity() -> BattingStatMO {
        return NSEntityDescription.insertNewObject(forEntityName: "BattingStat", into: self.managedObjectContext) as! BattingStatMO
    }
    
    func createPitchingStatEntity() -> PitchingStatMO {
        return NSEntityDescription.insertNewObject(forEntityName: "PitchingStat", into: managedObjectContext) as! PitchingStatMO
    }
}
