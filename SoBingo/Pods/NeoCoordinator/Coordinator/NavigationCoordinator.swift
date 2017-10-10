//
//  NavigationCoordinator.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 27/07/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit

open class NavigationCoordinator: Coordinator {
  
  public var controller: UIViewController?
  
  public let context: Context
  public let navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  required public init(navigationController: UINavigationController, parentCoordinator: Coordinator?, context: Context) {
    
    self.context = context
    self.parentCoordinator = parentCoordinator
    self.navigationController = navigationController
  }
  
  open func setup() throws {
    throw CoordinatorError.badImplementation("‼️ERROR‼️ : Method `setup` should be overriden for the coordinator \(self)")
  }
}

public extension NavigationCoordinator {
  
  func start(withCallback completion: CoordinatorCallback? = nil) throws {
    
    try setup()
    
    guard let controller = controller else {
      throw CoordinatorError.badImplementation("‼️ERROR‼️ : You must have initialized the controller in method `setup` for coordinator \(self)")
    }
    
    navigationController.tabBarItem = controller.tabBarItem
    navigationController.pushViewController(controller, animated: true) { [weak self] in
      guard let strongSelf = self else { return }
      completion?(strongSelf)
    }
  }
  
  func stop(withCallback completion: CoordinatorCallback? = nil) {
    
    if let controller = controller,
      navigationController.viewControllers.contains(controller) {
      navigationController.popViewController(animated: true) { [weak self] in
        guard let strongSelf = self else { return }
        completion?(strongSelf)
      }
    }
  }
}
