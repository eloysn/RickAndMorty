//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by eloysn on 22/3/23.
//

import SwiftUI

struct CharacterDetailView: View {
    let id: Int
    @ObservedObject var viewModel = CharacterDetailViewModel()
    
    var body: some View {
        let isPresented = Binding<Bool>(
            get: { viewModel.state.showError },
             set: { _ in }
        )
        ZStack(alignment: .center) {
            if let character = viewModel.state.character {
                CharacterItemView(character: character)
            } else {
                emptyView
            }
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
            viewModel.send(event: .onFetchData(id))
        }
    }
    
    private var emptyView: some View {
        Color(.gray.withAlphaComponent(0.5))
        .ignoresSafeArea()
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(id: 1)
    }
}
