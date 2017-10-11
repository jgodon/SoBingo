//
//  BingoCellViewModel.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 11/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BingoCellViewModelType {
  
  var word: Driver<String> { get }
  
  var selected: BehaviorSubject<Bool> { get }
  
  init(word: String)
}

struct BingoCellViewModel: BingoCellViewModelType {
  
  private let _word: String
  var word: Driver<String> {
    return Observable.just(_word)
      .asDriver(onErrorJustReturn: "")
  }
  
  let selected = BehaviorSubject<Bool>(value: false)
  
  init(word: String) {    
    _word = word
  }
}
