//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

import Foundation
struct CharactersResponse: Codable {
    let results: [CharacterResponse]
}

struct CharacterResponse: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
    let location: CharacterLocationResponse
    
}
struct CharacterLocationResponse: Codable {
    let name: String
}

extension Character {
    init(_ response: CharacterResponse) {
        self.init(
            id: response.id,
            name: response.name,
            status: Status(response.status),
            species: response.species,
            type: response.type,
            gender: Gender(response.gender),
            image: URL(string: response.image),
            episode: response.episode,
            url: URL(string: response.url),
            created:response.created,
            location: response.location.name
        )
    }
}
