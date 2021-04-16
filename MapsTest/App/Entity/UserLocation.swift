//
//  UserLocation.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 31.03.2021.
//

import Foundation
import RealmSwift

class UserLocation: Object {
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.lat = latitude
        self.long = longitude
    }
}
