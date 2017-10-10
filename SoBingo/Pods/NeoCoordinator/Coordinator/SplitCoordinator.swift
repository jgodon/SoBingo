//
//  SplitCoordinator.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 02/08/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation

open class SplitCoordinator: Coordinator {
  
  public var controller: UIViewController?
  
  public let context: Context
  public let navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  public var masterCoordinator: Coordinator.Type?
  public var detailCoordinator: Coordinator.Type?
  
  required public init(navigationController: UINavigationController, parentCoordinator: Coordinator?, context: Context) {
    
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.context = context
  }
  
  open func setup() throws {
    throw CoordinatorError.badImplementation("‼️ERROR‼️ : Method `setup` should be overriden for the coordinator \(self)")
  }
}

public extension SplitCoordinator {
  
  func start(withCallback completion: CoordinatorCallback? = nil) throws {
    
    try setup()
    
    self.navigationController.setNavigationBarHidden(true, animated: false)
    
    guard let masterCoordinatorType = self.masterCoordinator else {
      throw CoordinatorError.badImplementation("‼️ERROR‼️ : You must have initialized the masterCoordinator in method `setup` for coordinator \(self)")
    }
    guard let detailCoordinatorType = self.detailCoordinator else {
      throw CoordinatorError.badImplementation("‼️ERROR‼️ : You must have initialized the detailCoordinator in method `setup` for coordinator \(self)")
    }
    
    let splitViewController = UISplitViewController()
    
    // This is because an UISplitViewController has to be in root 😌🤢
    UIApplication.shared.windows.first?.rootViewController = splitViewController
    
    let masterNavController = UINavigationController()
    let masterCoordinator = masterCoordinatorType.init(navigationController: masterNavController, parentCoordinator: self, context: context)
    startChild(forCoordinator: masterCoordinator)
    
    let detailsNavController = UINavigationController()
    let detailsCoordinator = detailCoordinatorType.init(navigationController: detailsNavController, parentCoordinator: self, context: context)
    startChild(forCoordinator: detailsCoordinator)
    
    splitViewController.viewControllers = [masterNavController, detailsNavController]
    
    controller = splitViewController
  }
  
  func stop(withCallback completion: CoordinatorCallback? = nil) {
    
    navigationController.popViewController(animated: true) { [weak self] in
      guard let strongSelf = self else { return }
      completion?(strongSelf)
    }
  }
}
