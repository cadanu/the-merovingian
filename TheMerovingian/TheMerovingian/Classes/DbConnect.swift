//
//  DbConnect.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit
import SQLite3

class DbConnect: NSObject {
    var databaseName: String? = "the-merovingian.db"
    var databasePath: String?
    var db: OpaquePointer? = nil
    
//    override init() {
//        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentDir = documentPaths[0]
//        databasePath = documentDir.appending("/" + databaseName!)
//
//        var success = false
//        let fileManager = FileManager.default
//
//        success = fileManager.fileExists(atPath: databasePath!)
//        if success {
//            return// if file exists
//        }
//        // if not exists
//        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
//        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
//    }
    
    
    func openDatabase() -> Bool {
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(describing: self.databasePath)).")
            return true
        }
        else {
            print("Unable to open database.")
            return false
        }
    }
    
    
    func closeDatabase() {
        sqlite3_close(db)
    }
    
    func checkAndCreateDatabase() {
        var success = false
        let fileManager = FileManager.default

        success = fileManager.fileExists(atPath: databasePath!)
        if success {
            return// if file exists
        }
        // if not exists
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
    }

}
