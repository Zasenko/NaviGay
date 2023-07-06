//
//  User+CoreDataClass.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 23.05.23.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {
    func updateUser(decodedUser: DecodedUser) {
        self.bio = decodedUser.bio
        self.name = decodedUser.name
        self.photo = decodedUser.photo
        self.status = decodedUser.status.rawValue
        self.email = decodedUser.email
    }
}
