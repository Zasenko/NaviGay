//
//  DecodedUser.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import Foundation
struct LoginResult: Codable {
    var error: Int?
    var errorDescription: String?
    var user: DecodedUser?
}

enum UserStatus: String, Codable {
    case user, admin, moderator, partner, anonim
}

struct DecodedUser: Codable, Identifiable {
    let id: Int
    let name: String
    let status: UserStatus
    let email: String?
    let bio: String?
    let photo: String?
    let instagram: String?
    let likedPlacesId: [Int]?
}
