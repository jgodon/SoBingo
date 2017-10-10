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
  
  var words: Driver<[String]> { get }
  
  // ACTIONS
  
  var resetWords: Action<Void, [String]> { get }
}

struct GameViewModel: GameViewModelType {
  
  var resetWords: Action<Void, [String]>
  
  var words: Driver<[String]> {
    return resetWords.elements
      .asDriver(onErrorJustReturn: [])
  }
  
  init(gameInteractor: GameInteractorType) {

    resetWords = Action<Void, [String]> {
      gameInteractor.generateWords()
    }    
  }
}
