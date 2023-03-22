//
//  CharacterRepositoryTest.swift
//  RickAndMortyTests
//
//  Created by eloysn on 21/3/23.
//

import XCTest
import Combine
@testable import RickAndMorty

final class CharacterRepositoryTest: XCTestCase {
    
    private var sut: CharacterRepositoryImpl!
    private var mockService: MockApiService!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockApiService()
        sut = CharacterRepositoryImpl(apiService: mockService)
    }

    override func tearDownWithError() throws {
        mockService = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testFecthCharacters() {
        let expectation = XCTestExpectation(description: "Data is set to populated")
        sut
            .fecthCharacters()
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                XCTAssertEqual($0.count, 20)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        mockService.fetchResult.send(DataMock.validCharactersData)
        wait(for: [expectation], timeout: 1)
    }
    
    func testFecthCharacterById() {
        let expectation = XCTestExpectation(description: "Data is set to populated")
        sut
            .fecthCharacter(by: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                XCTAssertEqual($0.name, "Rick Sanchez")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        mockService.fetchResult.send(DataMock.validCharacterData)
        wait(for: [expectation], timeout: 1)
    }
}
