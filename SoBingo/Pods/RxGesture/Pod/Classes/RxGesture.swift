// Copyright (c) 2016 Marin Todorov <marin@underplot.com>

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import RxSwift
import RxCocoa

/// An OptionSetType to provide a list of valid gestures
public struct RxGestureTypeOptions : OptionSet, Hashable {
    
    private let raw: UInt
    
    public init(rawValue: UInt) {
        raw = rawValue
    }
    public var rawValue: UInt {
        return raw
    }
    
    public var hashValue: Int { return Int(rawValue) }
    
    public static var none = RxGestureTypeOptions(rawValue: 0)
    public static var tap  = RxGestureTypeOptions(rawValue: 1 << 0)
    
    public static var swipeLeft  = RxGestureTypeOptions(rawValue: 1 << 1)
    public static var swipeRight = RxGestureTypeOptions(rawValue: 1 << 2)
    public static var swipeUp    = RxGestureTypeOptions(rawValue: 1 << 3)
    public static var swipeDown  = RxGestureTypeOptions(rawValue: 1 << 4)
    
    public static var longPress  = RxGestureTypeOptions(rawValue: 1 << 5)
    
    public static func all() -> RxGestureTypeOptions {
        return [.tap, .swipeLeft, .swipeRight, .swipeUp, .swipeDown, .longPress]
    }
}

extension Reactive where Base: UIView  {
    
    /// Reactive wrapper for view gestures. You can observe a single gesture or multiple gestures
    /// (e.g. swipe left and right); the value the Observable emits is the type of the concrete gesture
    /// out of the list you are observing.
    ///
    /// rx_gesture can't error, shares side effects and is subscribed/observed on main scheduler
    /// - parameter type: list of types you want to observe like `[.Tap]` or `[.SwipeLeft, .SwipeRight]`
    /// - returns: `baseEvent<RxGestureTypeOptions>` that emits any type one of the desired gestures is performed on the view
    /// - seealso: `RxCocoa` adds `rx_tap` to `NSButton/UIButton` and is sufficient if you only need to subscribe
    ///   on taps on buttons. `RxGesture` on the other hand enables `userInteractionEnabled` and handles gestures on any view

    public func gesture(type: RxGestureTypeOptions) -> ControlEvent<RxGestureTypeOptions> {
        let source: Observable<RxGestureTypeOptions> = Observable.create { observer in
            MainScheduler.ensureExecutingOnScheduler()
            
          guard !type.isEmpty else {
            observer.onCompleted()
            return Disposables.create()
            }
            
          self.base.isUserInteractionEnabled = true
            
            var gestures = [Disposable]()
            
            //taps
            if type.contains(.tap) {
                let tap = UITapGestureRecognizer()
                self.base.addGestureRecognizer(tap)
                gestures.append(
                    tap.rx.event.map {_ in RxGestureTypeOptions.tap}
                      .bind(onNext: observer.onNext)
                )
            }
            
            //swipes
            for direction in Array<RxGestureTypeOptions>([.swipeLeft, .swipeRight, .swipeUp, .swipeDown]) {
                if type.contains(direction) {
                  if let swipeDirection = self.directionForGestureType(type: direction) {
                        let swipe = UISwipeGestureRecognizer()
                        swipe.direction = swipeDirection
                        self.base.addGestureRecognizer(swipe)
                        gestures.append(
                            swipe.rx.event.map {_ in direction}
                              .bind(onNext: observer.onNext)
                        )
                    }
                }
            }
            
            //long press
            if type.contains(.longPress) {
                let press = UILongPressGestureRecognizer()
                self.base.addGestureRecognizer(press)
                gestures.append(
                    press.rx.event.map {_ in RxGestureTypeOptions.longPress}
                      .bind(onNext: observer.onNext)
                )
            }
            
            //dispose gestures
            return Disposables.create {
                for gesture in gestures {
                    gesture.dispose()
                }
            }
          }
        
        return ControlEvent(events: source)
    }
    
    private func directionForGestureType(type: RxGestureTypeOptions) -> UISwipeGestureRecognizerDirection? {
      if type == .swipeLeft  { return .left  }
      if type == .swipeRight { return .right }
      if type == .swipeUp    { return .up    }
      if type == .swipeDown  { return .down  }
        return nil
    }
}
