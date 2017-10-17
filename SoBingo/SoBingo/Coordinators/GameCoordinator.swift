//
//  GameCoordinator.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import NeoCoordinator
import RxCoordinator
import Action
import Reusable
import Swinject
import RxSwift

final class GameCoordinator: NavigationCoordinator, RxCoordinator {
  
  let disposeBag = DisposeBag()
  
  override func setup() {
    
    let builder: Builder = try! context.value()
    let controller = GameViewController.instantiate(andInject: builder.container)
    self.controller = controller
    let config = CoordinatorConfiguration(type: SuccessCoordinator.self)
    controller.viewModel.wonAction = startRxChildAction(forConfiguration: config)
    navigationController.navigationBar.isHidden = true
  }
}
