//
//  RxCoordinator.swift
//  Coordinator
//
//  Created by Xavier De Koninck on 01/08/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import Foundation
import NeoCoordinator
import RxSwift
import RxCocoa
import Action

public protocol RxCoordinator: Coordinator {
  
  /// The rx dispose bag to manage the sequences resources
  /// @see https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#disposing for more information
  var disposeBag: DisposeBag { get }
  
  /// Rx Action implementation of start to use it as a sequence
  /// Call `start` under the hood
  var startRxAction: CocoaAction { get }
  
  /// Rx Action implementation of stop to use it as a sequence
  /// Call `stopFromParent` under the hood
  var stopRxAction: CocoaAction { get }

  /// Rx Action implementation of start child to use it as a sequence
  /// Call `startChildCoordinator(forConfiguration:)` under the hood
  func startRxChildAction(forConfiguration config: CoordinatorConfiguration) -> CocoaAction
  
  /// Rx Action implementation of stop child to use it as a sequence
  /// Call `stopChild(forCoordinator:)` under the hood
  func stopRxChildAction(forCoordinator coordinator: Coordinator) -> CocoaAction
}

public extension RxCoordinator {
  
  // MARK: Start coordinator / Rx Action wrapper
  
  var startRxAction: CocoaAction {
    
    return CocoaAction { [weak self] _ in
      return Observable.create { [weak self] (observer) in
        try? self?.start() { _ in
          observer.onNext()
          observer.onCompleted()
        }
        return Disposables.create()
      }
    }
  }
  
  // MARK: Stop coordinator / Rx Action wrapper
  
  var stopRxAction: CocoaAction {
    
    return CocoaAction { [weak self] _ in
      return Observable.create { [weak self] (observer) in
        self?.stopFromParent({ _ in
          observer.onNext()
          observer.onCompleted()
        })
        return Disposables.create()
      }
    }
  }
  
  // MARK: Start child / Rx Action wrapper
  
  func startRxChildAction(forConfiguration config: CoordinatorConfiguration) -> CocoaAction {
    
    return CocoaAction { [weak self] in
      return Observable.create { [weak self] (observer) in
        self?.startChildCoordinator(forConfiguration: config, callback: { coordinator in
          observer.onNext()
          observer.onCompleted()
        })
        return Disposables.create()
      }
    }
  }
  
  // MARK: Stop child / Rx Action wrapper
  
  func stopRxChildAction(forCoordinator coordinator: Coordinator) -> CocoaAction {
    
    return CocoaAction { [weak self] in
      return Observable.create { [weak self, weak coordinator] (observer) in
        if let coordinator = coordinator {
          self?.stopChild(forCoordinator: coordinator, callback: { coordinator in
            observer.onNext()
            observer.onCompleted()
          })
        }
        return Disposables.create()
      }
    }
  }
}
