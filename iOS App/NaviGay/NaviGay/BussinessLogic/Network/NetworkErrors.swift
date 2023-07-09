//
//  NetworkManagerErrors.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 28.04.23.
//

import Foundation

enum NetworkErrors: Error {
    case noConnection
    case decoderError
    case bedUrl
    case invalidData
    case apiError
    case noUser
    case apiErrorWithMassage(String)
}
