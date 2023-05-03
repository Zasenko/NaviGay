//
//  NetworkManagerErrors.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 28.04.23.
//

import Foundation

enum NetworkManagerErrors: Error {
    case noConnection
    case decoderError
    case bedUrl
    case invalidData
    case apiError
}
