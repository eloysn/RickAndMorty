//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by eloysn on 22/3/23.
//

import Combine
import Foundation

protocol CharactersUseCase {
    func fecthCharacters(restart: Bool) -> AnyPublisher<[Character], DomainError>
}

final class CharactersUseCaseImpl: CharactersUseCase {
    
    private let characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository = CharacterRepositoryImpl(apiService: RemoteServiceImpl())) {
        self.characterRepository = characterRepository
    }
    
    func fecthCharacters(restart: Bool) -> AnyPublisher<[Character], DomainError> {
        characterRepository
            .fecthCharacters(restart: restart)
            .mapError { error  in
                guard let error = error as? NetworkHandlerError else { return .UnknownError }
                switch error {
                case .RequestError: return .RequestError
                case .UnknownError, .JSONDecodingError, .InvalidURL: return .UnknownError
                }
            }
            .eraseToAnyPublisher()
    }
}

