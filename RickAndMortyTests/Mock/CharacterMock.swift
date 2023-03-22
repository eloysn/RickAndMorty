//
//  CharacterMock.swift
//  RickAndMortyTests
//
//  Created by eloysn on 22/3/23.
//

import Foundation
@testable import RickAndMorty

final class CharacterMock {
    static var entity: Character {
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
            episode: [],
            url: URL(string: "https://rickandmortyapi.com/api/location/4")!,
            created: "2017-11-04T18:48:46.250Z",
            location: "Dorian 5")
    }
}

