//
//  TabBarCoordinator.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 27/07/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit

/// Default implementation of a coordinator using UITabBarController
open class TabBarCoordinator: Coordinator {
  
  /// The reference of the controller which is owned by the coordinator
  /// Can be nil in case of conditionnal transition coordinator
  public var controller: UIViewController?
  
  /// Some object holding information about the application context. Database references, user settings etc.
  public let context: Context
  
  /// The navigation controller used by the coordinator.
  public let navigationController: UINavigationController
  
  /// The optionnal parent coordinator
  public weak var parentCoordinator: Coordinator?
  
  // All the children of the coordinator are retained here.
  public var childCoordinators: [Coordinator] = []
  
  // The children coordinator composing the tabBar elements.
  public var tabs: [Coordinator.Type] = []
  
  /// Force a uniform initializer on our implementors.
  required public init(navigationController: UINavigationController, parentCoordinator: Coordinator?, context: Context) {
    
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.context = context
  }
  
  open func setup() throws {
    throw CoordinatorError.badImplementation("‼️ERROR‼️ : Method `setup` should be overriden for the coordinator \(self)")
  }
}

public extension TabBarCoordinator {
  
  func start(withCallback completion: CoordinatorCallback? = nil) throws {
    
    try setup()
    
    guard tabs.count > 0 else {
      throw CoordinatorError.badImplementation("‼️ERROR‼️ : You must insert at least one coordinator in tabs array for coordinator \(self)")
    }
    
    let tabBarController = UITabBarController()
    
    navigationController.setNavigationBarHidden(true, animated: false)
    tabBarController.viewControllers = tabs.map { childCoordinator in
      
      let navigationController = UINavigationController()
      let coordinator = childCoordinator.init(navigationController: navigationController, parentCoordinator: self, context: context)
      startChild(forCoordinator: coordinator, callback: nil)
      
      return navigationController
    }
    
    controller = tabBarController
    
    navigationController.pushViewController(tabBarController, animated: true) { [weak self] in
      guard let strongSelf = self else { return }
      completion?(strongSelf)
    }
  }
  
  func stop(withCallback completion: CoordinatorCallback? = nil) {
    
    navigationController.popViewController(animated: true) { [weak self] in
      guard let strongSelf = self else { return }
      completion?(strongSelf)
    }
  }
}
