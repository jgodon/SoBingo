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

protocol GameViewModelType {
  
  // OUTPUT
  
  var nbWords: Int { get }
  var words: Driver<[BingoCellViewModelType]> { get }  
  
  // ACTIONS
  
  var resetWords: Action<Void, [String]> { get }
}

struct GameViewModel: GameViewModelType {
  
  private let gameInteractor: GameInteractorType
  
  var resetWords: Action<Void, [String]>
  
  var nbWords: Int {
    return gameInteractor.nbWords
  }
  
  var words: Driver<[BingoCellViewModelType]> {
    return resetWords.elements
      .map({ $0.map({ BingoCellViewModel(word: $0) }) })
      .asDriver(onErrorJustReturn: [])
  }
  
  init(gameInteractor: GameInteractorType) {

    self.gameInteractor = gameInteractor
    
    resetWords = Action<Void, [String]> {
      gameInteractor.generateWords()
    }    
  }
}
