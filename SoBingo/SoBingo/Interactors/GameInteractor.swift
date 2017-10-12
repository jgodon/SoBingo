//
//  GameInteractor.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import RxSwift

protocol GameInteractorType {
  
  var nbWords: Int { get }
  
  func generateWords() -> Observable<[String]>
}

struct GameInteractor: GameInteractorType {
  
  let nbWords = 6
  
  private let words: [String] = ["appétence",
                                 "absolument",
                                 "faire sens",
                                 "adhérence",
                                 "récurrence d’usage",
                                 "récence",
                                 "open bar",
                                 "point à craquer",
                                 "au fil de l'eau"]
  
  func generateWords() -> Observable<[String]>{
    
    return Observable.create({ observer in
      
      var w = self.words
      w.shuffle()
      
      observer.onNext(Array(w.prefix(self.nbWords)))
      observer.onCompleted()
      
      return Disposables.create()
    })
  }
}

extension MutableCollection where Index == Int {
  /// Shuffle the elements of `self` in-place.
  mutating func shuffle() {
    // empty and single-element collections don't shuffle
    if count < 2 { return }
    
    for i in startIndex ..< endIndex - 1 {
      let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
      if i != j {
        swapAt(i, j)
      }
    }
  }
}
