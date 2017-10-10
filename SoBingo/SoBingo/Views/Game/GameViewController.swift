//
//  GameViewController.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 10/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxOptional

final class GameViewController: UIViewController, StoryboardBased {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var resetButton: UIBarButtonItem!
  
  let disposeBag = DisposeBag()
  
  var viewModel: GameViewModelType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.words.drive(onNext: { print($0) })
    
    resetButton.rx.tap
      .bind(to: viewModel.resetWords.inputs)
      .addDisposableTo(disposeBag)
    
    viewModel.resetWords.execute()
  }
}
