//
//  NetworkHandlerError.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

enum NetworkHandlerError: Error {
    case InvalidURL
    case JSONDecodingError
    case RequestError
    case UnknownError
}
