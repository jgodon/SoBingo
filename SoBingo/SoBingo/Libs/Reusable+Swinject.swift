//
//  Reusable+Swinject.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit
import Reusable
import Swinject
import SwinjectStoryboard

// MARK: Support for instantiation from Storyboard with Swinject injection
public extension StoryboardBased where Self: UIViewController {
  
  /**
   Create an instance of the ViewController from its associated Storyboard's initialViewController
   - returns: instance of the conforming ViewController injected with Swinject
   */
  static func instantiate(andInject container: Resolver? = nil) -> Self {
    
    let viewController = SwinjectStoryboard.create(name: String(describing: self),
                                                   bundle: nil,
                                                   container: container ?? SwinjectStoryboard.defaultContainer).instantiateInitialViewController()
    guard let vc = viewController as? Self
      else {
        fatalError("The initialViewController of '\(String(describing: self))' is not of class '\(self)' but '\(String(describing: viewController))'")
    }
    return vc
  }
}
