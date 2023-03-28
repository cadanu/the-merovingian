//
//  AppDelegate.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var databaseName: String? = "the-merovingian.db"
    var databasePath: String?
    var userArray: [User] = []
    var playerArray: [Player] = []
    let avatarArray = ["viking", "outlaw", "hoodwink"]
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)// search for folders in the document directory
        
        let documentDir = documentPaths[0]// gets first index (e.g. ~/MyDocuments)
        databasePath = documentDir.appending("/" + databaseName!)// let db path = documentDir with slash appended
        
        checkAndCreateDatabase()
        readDataFromDatabase()
        
        return true
    }
    
    // read from multiple database
    func readDataFromDatabase() {
        userArray.removeAll()// empty array
        var db: OpaquePointer? = nil
        
        // open database connection
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var queryStatement: OpaquePointer? = nil;
            
            print("Successfully opened connection to database at \(String(describing: self.databasePath))");
            
            // select * from User
            let queryReadAllUser: String = "select * from User;";
            if sqlite3_prepare_v2(db, queryReadAllUser, -1, &queryStatement, nil) == SQLITE_OK {
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cName = sqlite3_column_text(queryStatement, 1)
                    let cEmail = sqlite3_column_text(queryStatement, 2)
                    let cCity = sqlite3_column_text(queryStatement, 3)
                    
                    let name = String(cString: cName!)
                    let email = String(cString: cEmail!)
                    let city = String(cString: cCity!)
                    
                    let data: User = User.init()
                    data.initWithData(theName: name, theEmail: email, theCity: city)
                    userArray.append(data)
                    
                    print("Query result")
                    print("\(id) | \(name) | \(email) | \(city)")
                }
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Unable to open database")
            }
            // end select * from User
            
            // select * from Player
            let queryReadAllPlayer: String = "select * from Player;";
            if sqlite3_prepare_v2(db, queryReadAllPlayer, -1, &queryStatement, nil) == SQLITE_OK {

                while sqlite3_step(queryStatement) == SQLITE_ROW {

                    let playerId: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cTag = sqlite3_column_text(queryStatement, 1)
                    let cLevel = sqlite3_column_text(queryStatement, 2)
                    let exp: Int = Int(sqlite3_column_int(queryStatement, 3))
                    let gold: Int = Int(sqlite3_column_int(queryStatement, 4))

                    let tag = String(cString: cTag!)
                    let level = String(cString: cLevel!)

                    let data: Player = Player.init()
                    data.initWithData(theId: playerId, theTag: tag, theLevel: level, theExp: exp, theGold: gold)
                    playerArray.append(data)

                    print("Query result")
                    print("\(playerId) | \(tag) | \(level) | \(exp) |\(gold)")
                }
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Unable to open database")
            }
            // end select * from Player
            
            
            // close db connection
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
        }
    }
    // end read from database
    
    // insert into database
    func insertIntoDatabase(user: User) -> Bool {
        var db: OpaquePointer? = nil
        var returnCode: Bool = true
        
        // open database connection
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var insertStatement: OpaquePointer? = nil
            var rowID: Int64 = 0
            
            // insert into User ...
            let insertIntoUser: String = "insert into User values(NULL, ?, ?, ?);"
            if sqlite3_prepare_v2(db, insertIntoUser, -1, &insertStatement, nil) == SQLITE_OK {
                // convert to c string
                let nameStr = user.name! as NSString
                let emailStr = user.email! as NSString
                let cityStr = user.city! as NSString
                // bind values to ?
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, cityStr.utf8String, -1, nil)
                // insert
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                }
                else {
                    print("Could not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else {
                print("Insert statement could not be prepared.")
                returnCode = false
            }
            
            // insert into Player
            if rowID > 0 {
                let insertIntoPlayer: String = "insert into Player values(?, ?, ?, NULL, NULL);"
                if sqlite3_prepare_v2(db, insertIntoPlayer, -1, &insertStatement, nil) == SQLITE_OK {
                    // convert to c compatible string
                    let tagStr = "Player\(rowID)" as NSString
                    let levelStr = "Peasant" as NSString
                    // bind values to ?
                    sqlite3_bind_int(insertStatement, 1, try! Int32(rowID))
                    sqlite3_bind_text(insertStatement, 2, tagStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 3, levelStr.utf8String, -1, nil)
                    // insert
                    if sqlite3_step(insertStatement) == SQLITE_DONE {
                        let rowID = sqlite3_last_insert_rowid(db)
                        print("Successfully inserted row \(rowID)")
                    }
                    else {
                        print("Could not insert row")
                        returnCode = false
                    }
                    sqlite3_finalize(insertStatement)
                }
                else {
                    print("Insert statement could not be prepared.")
                    returnCode = false
                }
            }
            
            
            // close db connection
            sqlite3_close(db)
        }
        else {
            print("Unable to open database.")
            returnCode = false
        }
        return returnCode
    }
    // end insert into database
    
    // check and create database
    func checkAndCreateDatabase() {
        var success = false
        let fileManager = FileManager.default// for the file system
        
        success = fileManager.fileExists(atPath: databasePath!)
        if success {
            return// if fileExists then exit method
        }
        // if file does not exist continue
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)// get path to database stored in app
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)// try to copy the database to databasePath
    }
    // end check and create database
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

