//
//  SuccessViewController.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 11/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxGesture
import Action
import AudioToolbox
import AVFoundation

final class SuccessViewController: UIViewController, StoryboardBased {
  
  var closeAction: CocoaAction!
  
  let disposeBag = DisposeBag()
  
  var player: AVAudioPlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.rx.gesture(type: .tap)
      .throttle(0.5, scheduler: MainScheduler.instance)
      .map({ _ in return })
      .bind(to: closeAction.inputs)
      .disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let url = Bundle.main.url(forResource: "Bingo", withExtension: "mp3")!
    
    do {
      player = try AVAudioPlayer(contentsOf: url)
      
      player.prepareToPlay()
      player.play()
    } catch let error as NSError {
      print(error.description)
    }
  }
}
