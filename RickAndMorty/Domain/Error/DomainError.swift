//
//  DomainError.swift
//  RickAndMorty
//
//  Created by eloysn on 22/3/23.
//

import Foundation

enum DomainError: Error, LocalizedError {
    case RequestError
    case UnknownError
    
    public var errorDescription: String? {
        switch self {
        case .RequestError: return "Error in the request"
        case .UnknownError: return "Unknown error try again later"
        }
    }
}
