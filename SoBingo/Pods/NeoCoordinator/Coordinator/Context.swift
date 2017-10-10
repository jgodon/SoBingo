//
//  Context.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 27/07/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation

/// The context is a wrapper of value passed to a coordinator to initialize his controller
/// The value contained in can be of any type
public struct Context {
  
  /// The object containing the value wrapped
  private let valueStored: Any
  
  
  /// The main init of the container
  ///
  /// - Parameter value: The object contained in the wrapper
  public init(value: Any) {
    
    self.valueStored = value
  }
  
  /// The method to get bqck the value contained casted
  ///
  /// - Returns: The value casted contained
  /// - Throws: Will throw an error if we ask of a bad value type
  public func value<T>() throws -> T {
    
    guard let value = valueStored as? T else {            
      throw ContextError.badType(T.self, type(of: valueStored))
    }
    return value
  }
  
  /// Enumeration of the possible errors for the context
  ///
  /// - badType: The value could not be casted in the type asked
  public enum ContextError: Error, CustomStringConvertible {
    
    case badType(Any, Any)
    
    public var description: String {
      
      switch self {
      case .badType(let bad, let good):
        return "WARNING! ⚠️ : Context value is not type of: \(bad) but type of \(good)!"
      }
    }
  }
}
