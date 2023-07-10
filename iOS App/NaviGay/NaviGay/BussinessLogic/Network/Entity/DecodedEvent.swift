//
//  DecodedEvent.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 10.07.23.
//

import Foundation

//enum EventType: String, Codable {
//    case party, pride
//}

struct EventResult: Codable {
    let error: String?
    let event: DecodedEvent?
}

struct DecodedEvent: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let cover: String? // почему ?  узнать api
    
    let address: String
    let latitude: Float
    let longitude: Float
    
    let startTime: String
    let finishTime: String
    
    let isActive: Int
    let isChecked: Int

    let tags: [String]
}
