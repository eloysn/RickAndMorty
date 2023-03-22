//
//  CharacterRepositoryMock.swift
//  RickAndMortyTests
//
//  Created by eloysn on 22/3/23.
//

import Combine
import Foundation
@testable import RickAndMorty

final class CharacterRepositoryMock: CharacterRepository  {
    
    var fetchCharacters = PassthroughSubject<[Character], Error>()
    var fetchCharacter = PassthroughSubject<Character, Error>()
    
    func fecthCharacters(restart: Bool = false) -> AnyPublisher<[Character], Error> {
        fetchCharacters
            .eraseToAnyPublisher()
    }
    
    func fecthCharacter(by id: Int) -> AnyPublisher<Character, Error> {
        fetchCharacter
            .eraseToAnyPublisher()
    }
}
