//
//  BingoCell.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 11/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxGesture

final class BingoCell: UICollectionViewCell, NibReusable {
  
  @IBOutlet weak var wordLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  func setup(with viewModel: BingoCellViewModelType) {
    
    viewModel.word
      .drive(wordLabel.rx.text)
      .disposed(by: disposeBag)
    
    rx.gesture(type: .tap)
      .withLatestFrom(viewModel.selected)
      .map(!)
      .bind(to: viewModel.selected)
      .disposed(by: disposeBag)
    
    viewModel.selected.asObservable()
      .map({ ($0) ? (UIColor.gray) : UIColor.white })
      .subscribe(onNext: { [weak self] in
        self?.backgroundColor = $0
      })
      .disposed(by: disposeBag)
  }
}
