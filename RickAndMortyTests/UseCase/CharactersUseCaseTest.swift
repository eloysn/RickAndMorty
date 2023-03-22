//
//  CharactersUseCaseTest.swift
//  RickAndMortyTests
//
//  Created by eloysn on 22/3/23.
//

import XCTest
import Combine
@testable import RickAndMorty

final class CharactersUseCaseTest: XCTestCase {
    
    private var sut: CharactersUseCaseImpl!
    private var mockRepository: CharacterRepositoryMock!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = .init()
        sut = .init(characterRepository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testFecthCharacters() {
        let expectation = XCTestExpectation(description: "Data is set to populated")
        sut.fecthCharacters(restart: false)
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                XCTAssertEqual($0.count, 2)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        mockRepository.fetchCharacters.send([CharacterMock.entity, CharacterMock.entity])
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestError() {
        let expectation = XCTestExpectation(description: "RequestError is set to populated")
        sut.fecthCharacters(restart: false)
            .sink(receiveCompletion: { comple in
                if case .failure(let error) = comple {
                    XCTAssertEqual(error, .RequestError)
                    expectation.fulfill()
                }
                expectation.fulfill()
            },
                  receiveValue: {_ in })
            .store(in: &cancellables)

        mockRepository.fetchCharacters.send(completion: .failure(NetworkHandlerError.RequestError))
        wait(for: [expectation], timeout: 1)
    }
    func testUnknownError() {
        let expectation = XCTestExpectation(description: "UnknownError is set to populated")
        sut.fecthCharacters(restart: false)
            .sink(receiveCompletion: { comple in
                if case .failure(let error) = comple {
                    XCTAssertEqual(error, .UnknownError)
                    expectation.fulfill()
                }
                expectation.fulfill()
            },
                  receiveValue: {_ in })
            .store(in: &cancellables)

        mockRepository.fetchCharacters.send(completion: .failure(NetworkHandlerError.JSONDecodingError))
        wait(for: [expectation], timeout: 1)
    }
}


