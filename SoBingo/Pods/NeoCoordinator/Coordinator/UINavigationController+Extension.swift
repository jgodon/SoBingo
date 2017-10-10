//
//  UINavigationController+Extension.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 31/07/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  
  public func pushViewController(_ viewController: UIViewController,  animated: Bool, completion: @escaping (() -> Void)) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    pushViewController(viewController, animated: animated)
    CATransaction.commit()
  }
  
  public func popViewController(animated: Bool, completion: @escaping (() -> Void)) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    popViewController(animated: animated)
    CATransaction.commit()
  }
}
