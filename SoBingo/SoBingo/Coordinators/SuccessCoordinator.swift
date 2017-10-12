//
//  SuccessCoordinator.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 11/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import NeoCoordinator
import RxCoordinator
import Action
import Reusable
import Swinject
import RxSwift

final class SuccessCoordinator: ModalCoordinator, RxCoordinator {
  
  let disposeBag = DisposeBag()
  
  override func setup() {
    
    let builder: Builder = try! context.value()
    let controller = SuccessViewController.instantiate(andInject: builder.container)
    self.controller = controller    
    controller.navigationItem.hidesBackButton = true
    controller.modalTransitionStyle = .flipHorizontal
  }
}

