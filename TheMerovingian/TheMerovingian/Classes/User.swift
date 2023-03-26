//
//  User.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit

class User: NSObject {
    var id: Int?
    var name: String?
    var email: String?
    var city: String?
    
    func initWithData(theRow i: Int, theName n: String, theEmail e: String, theCity c: String) {
        id = i
        name = n
        email = e
        city = c
    }
}
