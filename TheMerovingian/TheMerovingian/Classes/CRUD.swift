//
//  CRUD.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit
import SQLite3

class CRUD: NSObject {
    let dbconn = DbConnect()
    var db: OpaquePointer? = nil
    var queryStatement: OpaquePointer? = nil
    var userArray: [User] = []
    var playerArray: [Player] = []
    
    
    func readUserFromDatabase() -> [User] {
        if dbconn.openDatabase() {
            
            let queryStatementString: String = "select * from User;";
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cName = sqlite3_column_text(queryStatement, 1)
                    let cEmail = sqlite3_column_text(queryStatement, 2)
                    let cCity = sqlite3_column_text(queryStatement, 3)
                    
                    let name = String(cString: cName!)
                    let email = String(cString: cEmail!)
                    let city = String(cString: cCity!)
                    
                    let user: User = User.init()
                    user.initWithData(theName: name, theEmail: email, theCity: city)
                    userArray.append(user)
                    
                    print("Query result")
                    print("\(id) | \(name) | \(email) | \(city)")
                }
            }
            sqlite3_finalize(queryStatement)
        }
        dbconn.closeDatabase()
        return userArray
    }
    

}
