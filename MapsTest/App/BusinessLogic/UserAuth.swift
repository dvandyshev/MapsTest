//
//  UserAuth.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 06.04.2021.
//

import Foundation
import RealmSwift

class UserAuth {
    
    let realm = try! Realm()
    
    func isUserRegistered(user: User) -> Bool {
        guard let dbUser = realm.object(ofType: User.self, forPrimaryKey: user.login) else {
            return false
        }
        return ifPasswordApproach(basePassword: dbUser.password, userPassword: user.password)
    }
    
    func ifPasswordApproach(basePassword: String, userPassword: String) -> Bool {
        basePassword == userPassword
    }
    
    func addUser(user: User) {
        if let dbUser = realm.object(ofType: User.self, forPrimaryKey: user.login) {
            try! realm.write {
                dbUser.password = user.password
            }
        } else {
            try! realm.write {
                realm.add(user)
            }
        }
    }
}
