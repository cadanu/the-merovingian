//
//  Data.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit

class Data: NSObject {
    
    var savedName : String?
    var savedEmail : String?
    
    override init() {
        savedName = "Anon"
        savedEmail = "some@user.com"
    }
    
    func initWithData(theName : String, theEmail : String) {
        savedName = theName
        savedEmail = theEmail
    }

}
