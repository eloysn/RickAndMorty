//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by eloysn on 20/3/23.
//

import Foundation
import Combine

final class CharacterViewModel: ObservableObject {
    @Published private(set) var state = State()
    let charactersUseCase: CharactersUseCase
    var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init(
        charactersUseCase: CharactersUseCase = CharactersUseCaseImpl()
    ) {
        self.charactersUseCase = charactersUseCase
        Publishers.system(
            initial: state,
            reduce: reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                whenLoading(),
                userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension CharacterViewModel {
    struct State {
        var status = Status.idle
        var characters = [Character]()
        var filterCharacters = [Character]()
        var showError: Bool = false
        var errorMessage: String = ""
    }
    
    enum Status: Equatable {
        case idle
        case loading
        case loaded
    }
    
    enum Event {
        case onSearch(String)
        case onRefreshData
        case onFetchData
        case onCharactersLoaded([Character])
        case onFailedToLoad(DomainError)
        case onResetError
    }
}

extension CharacterViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        var newState = state
        switch event {
        case .onSearch(let query):
            newState.filterCharacters = query.isEmpty ? newState.characters : filterCharacterName(query, newState.characters)
        case .onRefreshData:
            newState.characters = []
            newState.status = .loading
        case .onFetchData:
            newState.status = .loading
        case .onCharactersLoaded(let characters):
            newState.characters += characters
            newState.filterCharacters = filterCharacterName("", newState.characters)
            newState.status = .loaded
        case .onFailedToLoad(let error):
            newState.showError = true
            newState.errorMessage = error.errorDescription ?? ""
            newState.status = .loaded
        case .onResetError:
            newState.showError = false
            newState.errorMessage = ""
        }
        return newState
    }
    
    func whenLoading() -> Feedback<State, Event> {
        Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state.status else { return Empty().eraseToAnyPublisher() }
            guard let self = self else { return Empty().eraseToAnyPublisher() }
            return self.charactersUseCase
                .fecthCharacters(restart: state.characters.isEmpty)
                .map { Event.onCharactersLoaded($0) }
                .catch { Just(Event.onFailedToLoad($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
    private func filterCharacterName(_ query: String, _ characters: [Character]) -> [Character] {
        guard !query.isEmpty else { return characters}
        return characters.filter { $0.name.contains(query) }
    }
}
