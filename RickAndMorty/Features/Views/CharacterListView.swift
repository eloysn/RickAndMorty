//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by eloysn on 21/3/23.
//


import SwiftUI

struct CharacterListView: View {
    @State var text: String = ""
    var characterList: [Character]
    var actionHandler: (CharacterViewModel.Event) -> Void
    var body: some View {
        List {
            ForEach(characterList) { characater  in
                NavigationLink(
                    destination: CharacterDetailView(id: characater.id),
                    label: {
                        CharacterItemView(character: characater)
                            .onAppear {
                                if characterList.last == characater {
                                    actionHandler(.onFetchData)
                                }
                            }
                    }
                )
            }
            .listRowBackground(Color.clear)
        }
        .refreshable {
            actionHandler(.onRefreshData)
        }
        .searchable(text: $text, prompt: "Search...")
            .onChange(of: text) { actionHandler(.onSearch($0)) }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(characterList: [Character.characterPreview]) { _ in }
    }
}
