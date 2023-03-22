//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by eloysn on 22/3/23.
//

import Foundation
import Combine

final class CharacterDetailViewModel: ObservableObject {
    @Published var state = State()
    let characterUseCase: CharacterUseCase
    var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init(
        characterUseCase: CharacterUseCase = CharacterUseCaseImpl()
    ) {
        self.characterUseCase = characterUseCase
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

extension CharacterDetailViewModel {
    struct State {
        var id: Int?
        var status = Status.idle
        var character: Character?
        var showError: Bool = false
        var errorMessage: String = ""
    }
    
    enum Status: Equatable {
        case idle
        case loading
        case loaded
    }
    
    enum Event {
        case onFetchData(_ id: Int)
        case onCharacterLoaded(Character)
        case onFailedToLoad(DomainError)
        case onResetError
    }
}

extension CharacterDetailViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        var newState = state
        switch event {
        case .onFetchData(let id):
            newState.status = .loading
            newState.id = id
        case .onCharacterLoaded(let character):
            newState.status = .loaded
            newState.character = character
        case .onFailedToLoad(let error):
            newState.status = .loaded
            newState.showError = true
            newState.errorMessage = error.errorDescription ?? "Error"
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
            guard let id = state.id else { return Empty().eraseToAnyPublisher() }
            return self.characterUseCase
                .fecthCharacter(by: id)
                .map { Event.onCharacterLoaded($0) }
                .catch { Just(Event.onFailedToLoad($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

