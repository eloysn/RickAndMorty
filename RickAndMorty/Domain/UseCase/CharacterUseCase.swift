//
//  CharacterUseCase.swift
//  RickAndMorty
//
//  Created by eloysn on 22/3/23.
//

import Combine
import Foundation

protocol CharacterUseCase {
    func fecthCharacter(by id: Int) -> AnyPublisher<Character, DomainError>
}

final class CharacterUseCaseImpl: CharacterUseCase {
    
    private let characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository = CharacterRepositoryImpl(apiService: RemoteServiceImpl())) {
        self.characterRepository = characterRepository
    }
    
    func fecthCharacter(by id: Int) -> AnyPublisher<Character, DomainError> {
        characterRepository
            .fecthCharacter(by: id)
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
