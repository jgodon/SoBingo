//
//  MainBuilder.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

protocol Builder {
  
  var container: Container { get }
  
  init()
}

struct MainBuilder: Builder {
  
  let container = Container()
  
  init() {
    
    assembleInteractors()
    assembleGame()
  }

  fileprivate func assembleInteractors() {
    
    container.autoregister(GameInteractorType.self, initializer: GameInteractor.init)    
  }
  
  fileprivate func assembleGame() {
    
    container.autoregister(GameViewModelType.self, initializer: GameViewModel.init)
    container.storyboardInitCompleted(GameViewController.self) { r, c in
      c.viewModel = r.resolve(GameViewModelType.self)!
    }
  }
}
