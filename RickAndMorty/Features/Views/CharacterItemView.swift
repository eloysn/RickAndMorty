//
//  CharacterItemView.swift
//  RickAndMorty
//
//  Created by eloysn on 21/3/23.
//

import SwiftUI

struct CharacterItemView: View {
    @Environment(\.imageCache) var cache: ImageCache
    var character: Character
    var body: some View {
        VStack(alignment: .leading) {
            poster
                .padding()
            info.frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .leading
            )
            .padding()
        }
        .background(.gray.opacity(0.5))
    }
    
    private var poster: some View {
        character.image.map { url in
            AsyncImage(url: url,
                       cache: cache,
                       placeholder: ProgressView(),
                       configuration: { $0.resizable().renderingMode(.original) })
        }
        .scaledToFit()
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.width / 3,
               height: UIScreen.main.bounds.width / 3)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(character.name).font(.title2)
            HStack {
                Color(character.status.color)
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                Text("\(character.status.rawValue) - \(character.species)")
                    .font(.caption)
            }
            Text("Last known location:")
                .font(.caption)
            Text(character.location)
                .font(.title3)
        }
        .foregroundColor(.white)
    }
    
}

struct CharacterItemView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterItemView(character: Character.characterPreview)
    }
}
