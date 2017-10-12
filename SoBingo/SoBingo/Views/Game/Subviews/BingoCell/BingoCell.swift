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
  
  fileprivate let radius: CGFloat = 24.0
  
  @IBOutlet weak var wordLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  func setup(with viewModel: BingoCellViewModelType, andIndex index: Int) {
    
    viewModel.word
      .drive(wordLabel.rx.text)
      .disposed(by: disposeBag)        
    
    rx.gesture(type: .tap)
      .withLatestFrom(viewModel.selected)
      .map(!)
      .bind(to: viewModel.selected)
      .disposed(by: disposeBag)
    
    viewModel.selected.asObservable()
      .map({ ($0) ? (UIColor(red: 241.0/255.0, green: 228.0/255.0, blue: 66.0/255.0, alpha: 1)) : (.white) })
      .subscribe(onNext: { [weak self] in
        self?.backgroundColor = $0
      })
      .disposed(by: disposeBag)
    
    setupDesign(for: index)
  }
  
  fileprivate func setupDesign(for index: Int) {
    
    let path: UIBezierPath
    
    if layer.sublayers?.count ?? 0 > 1 {
      layer.sublayers?.removeLast()
    }
    
    if index % 2 == 0 {
      path = UIBezierPath(roundedRect: bounds,
                          byRoundingCorners:[.topRight, .bottomRight],
                          cornerRadii: CGSize(width: radius, height: radius))
    }
    else {
      path = UIBezierPath(roundedRect: bounds,
                          byRoundingCorners:[.topLeft, .bottomLeft],
                          cornerRadii: CGSize(width: radius, height: radius))
    }
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
    
    let borderLayer = CAShapeLayer()
    borderLayer.path = maskLayer.path
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0).cgColor
    borderLayer.lineWidth = 6
    borderLayer.frame = bounds
    layer.addSublayer(borderLayer)
  }
}
