//
//  AppCoordinator.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import NeoCoordinator

final class AppCoordinator: Coordinator {
  
  let context: Context
  var controller: UIViewController?
  
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController, parentCoordinator: Coordinator?, context: Context) {
    
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.context = context
  }
  
  func start(withCallback completion: CoordinatorCallback? = nil) throws {
    
    let config = CoordinatorConfiguration(type: GameCoordinator.self)
    self.startChildCoordinator(forConfiguration: config, callback: completion)
  }
  
  func stop(withCallback completion: CoordinatorCallback? = nil) {
    completion?(self)
  }
}
