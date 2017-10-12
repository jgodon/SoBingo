//
//  GameViewModel.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxOptional

protocol GameViewModelType {
  
  // OUTPUT
  
  var nbWords: Int { get }
  var words: Driver<[BingoCellViewModelType]> { get }  
  
  // ACTIONS
  
  var wonAction: CocoaAction? { get set }
  var resetWords: Action<Void, [String]> { get }
}

struct GameViewModel: GameViewModelType {
  
  private let gameInteractor: GameInteractorType
  
  var resetWords: Action<Void, [String]>
  
  var wonAction: CocoaAction? {
    didSet {
      _words.asObservable()
        .subscribe(onNext: setupValidation)
        .disposed(by: disposeBag)
    }
  }
  
  let disposeBag = DisposeBag()
  
  var nbWords: Int {
    return gameInteractor.nbWords
  }
  
  private let _words = Variable<[BingoCellViewModelType]>([])
  
  var words: Driver<[BingoCellViewModelType]> {
    return _words.asDriver()
  }
  
  init(gameInteractor: GameInteractorType) {
    
    self.gameInteractor = gameInteractor
    
    resetWords = Action<Void, [String]> {
      gameInteractor.generateWords()
    }
    
    resetWords.elements
      .map({ (words) -> [BingoCellViewModelType] in words.map({ BingoCellViewModel(word: $0) }) })
      .bind(to: _words)
      .disposed(by: disposeBag)
  }
  
  func setupValidation(_ viewModels: [BingoCellViewModelType]) {
    
    let validArray = viewModels.map({ $0.selected.asObservable() })
    
    if let wonAction = wonAction {
      Observable.combineLatest(validArray)
        .map({
          $0.reduce(true, { res, value in
            return res && value
          })
        })
        .filter({ $0 })
        .map({ _ in return })
        .bind(to: wonAction.inputs)
        .disposed(by: self.disposeBag)
    }
  }
}
