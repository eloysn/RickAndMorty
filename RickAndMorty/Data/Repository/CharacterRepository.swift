//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

import Combine
import Foundation
 
protocol CharacterRepository {
    func fecthCharacters(restart: Bool) -> AnyPublisher<[Character], Error>
    func fecthCharacter(by id: Int) -> AnyPublisher<Character, Error>
}

final class CharacterRepositoryImpl: CharacterRepository {
    private let apiService: RemoteApiService
    private var offset = 1
    
    public init(
        apiService: RemoteApiService = RemoteServiceImpl()
    ) {
        self.apiService = apiService
    }
    
    private func restart() {
        offset = 1
    }

    func fecthCharacters(restart: Bool = false) -> AnyPublisher<[Character], Error> {
        if restart { self.restart() }
        let method = "character/" + "?page=" + String(offset)
        guard let url = URL(string: apiService.baseURL + method) else { return Fail(error: NetworkHandlerError.RequestError).eraseToAnyPublisher() }
        return apiService
            .run(URLRequest(url: url))
            .map { (response: CharactersResponse) -> [Character] in response.results.map(Character.init) }
            .handleEvents(receiveOutput: { _ in self.offset += 1 })
            .eraseToAnyPublisher()
    }
    
    func fecthCharacter(by id: Int) -> AnyPublisher<Character, Error> {
        let method = "character/" + String(id)
        guard let url = URL(string: apiService.baseURL + method) else { return Fail(error: NetworkHandlerError.RequestError).eraseToAnyPublisher() }
        return apiService
            .run(URLRequest(url: url))
            .map { (response: CharacterResponse) -> Character in Character(response) }
            .eraseToAnyPublisher()
    }
}
