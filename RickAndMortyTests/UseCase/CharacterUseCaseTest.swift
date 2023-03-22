//
//  CharacterUseCaseTest.swift
//  RickAndMortyTests
//
//  Created by eloysn on 22/3/23.
//

import XCTest
import Combine
@testable import RickAndMorty

final class CharacterUseCaseTest: XCTestCase {
    
    private var sut: CharacterUseCaseImpl!
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

    func testFecthCharacter() {
        let expectation = XCTestExpectation(description: "Data is set to populated")
        sut.fecthCharacter(by: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                XCTAssertEqual($0.id, 1)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        mockRepository.fetchCharacter.send(CharacterMock.entity)
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestError() {
        let expectation = XCTestExpectation(description: "RequestError is set to populated")
        sut.fecthCharacter(by: 1)
            .sink(receiveCompletion: { comple in
                if case .failure(let error) = comple {
                    XCTAssertEqual(error, .RequestError)
                    expectation.fulfill()
                }
                expectation.fulfill()
            },
                  receiveValue: {_ in })
            .store(in: &cancellables)
        
        mockRepository.fetchCharacter.send(completion: .failure(NetworkHandlerError.RequestError))
        wait(for: [expectation], timeout: 1)
    }
    func testUnknownError() {
        let expectation = XCTestExpectation(description: "UnknownError is set to populated")
        sut.fecthCharacter(by: 1)
            .sink(receiveCompletion: { comple in
                if case .failure(let error) = comple {
                    XCTAssertEqual(error, .UnknownError)
                    expectation.fulfill()
                }
                expectation.fulfill()
            },
                  receiveValue: {_ in })
            .store(in: &cancellables)
        
        mockRepository.fetchCharacter.send(completion: .failure(NetworkHandlerError.JSONDecodingError))
        wait(for: [expectation], timeout: 1)
    }
}

