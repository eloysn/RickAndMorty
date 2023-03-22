//
//  Character.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

import Foundation
import UIKit

struct Character: Identifiable, Equatable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let image: URL?
    let episode: [String]
    let url: URL?
    let created: String
    let location: String
    
}

enum Status: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    case none = ""
    
    init(_ value: String) {
        self = Status(rawValue: value) ?? .none
    }
    
    var color: UIColor {
        switch self {
        case .alive: return .green
        case .dead: return .red
        case .unknown, .none: return .gray
        }
    }
}

 enum Gender: String {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    case none = ""
    
    init(_ value: String) {
        self = Gender(rawValue: value) ?? .none
    }
}

extension Character {
    static var characterPreview: Self {
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
