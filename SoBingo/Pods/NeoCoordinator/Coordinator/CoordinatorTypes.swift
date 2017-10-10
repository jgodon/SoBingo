//
//  CoordinatorTypes.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 31/07/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation

/// The configuration needed to create a child coordinator
public struct CoordinatorConfiguration {
  
  /// The coordinator type to be created
  let type: Coordinator.Type
  
  /// The optionnal context containing value(s)/object(s) needed by the child
  let context: Context?
  
  
  /// Main init of a context
  ///
  /// - Parameters:
  ///   - type: The child coordinator type
  ///   - context: The context
  public init(type: Coordinator.Type, context: Context? = nil) {
    
    self.type = type
    self.context = context
  }
}


/// The enumeration of possible Coordinator errors
///
/// - badImplementation: This error is throw when the coordinator does not implement all the things needed
public enum CoordinatorError: Error, CustomStringConvertible {
  
  case badImplementation(String)
  
  public var description: String {
    
    switch self {
    case .badImplementation(let str):
      return str
    }
  }
}
