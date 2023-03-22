//
//  RemoteService.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

import Foundation
import Combine

protocol RemoteApiService {
    var baseURL: String { get }
    func run<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

final class RemoteServiceImpl: RemoteApiService {
    let baseURL: String = "https://rickandmortyapi.com/api/"
    
    func run<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!) })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is DecodingError:
                   return NetworkHandlerError.JSONDecodingError
                case is URLError:
                    return NetworkHandlerError.InvalidURL
                default:
                    return NetworkHandlerError.UnknownError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

