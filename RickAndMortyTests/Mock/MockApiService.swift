//
//  MockApiService.swift
//  RickAndMortyTests
//
//  Created by eloysn on 21/3/23.
//

import Combine
import Foundation
@testable import RickAndMorty

final class MockApiService: RemoteApiService {
    let baseURL: String = "https://rickandmortyapi.com/api/"
    var fetchResult = PassthroughSubject<Data, Error>()
    func run<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        fetchResult
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

final class DataMock {
    static var validCharactersData: Data { return jsonData("characters_mock") }
    static var validCharacterData: Data { return jsonData("character_mock") }
    
    private static func jsonData(_ filename: String) -> Data {
        let path = Bundle(for: self).path(forResource: filename, ofType: "json")!
        let jsonString = try! String(contentsOfFile: path, encoding: .utf8)
        return jsonString.data(using: .utf8)!
    }
}

