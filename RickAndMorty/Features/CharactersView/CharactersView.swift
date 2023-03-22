//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

import SwiftUI

struct CharactersView: View {
    @ObservedObject var viewModel = CharacterViewModel()
    var body: some View {
        let isPresented = Binding<Bool>(
            get: { viewModel.state.showError },
             set: { _ in }
        )
        NavigationView {
            CharacterListView(characterList: viewModel.state.filterCharacters) {
                viewModel.send(event: $0)
            }
            .navigationTitle("Characters")
        }
        .alert("\(viewModel.state.errorMessage)", isPresented: isPresented) {
            Button("OK", role: .cancel) {
                viewModel.send(event: .onResetError)
            }
        }
        .overlay {
            if viewModel.state.status == .loading {
                ProgressView("Loading....")
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            viewModel.send(event: .onFetchData)
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
