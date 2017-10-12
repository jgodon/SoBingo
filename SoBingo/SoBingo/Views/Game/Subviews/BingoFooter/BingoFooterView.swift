//
//  BingoFooter.swift
//  SoBingo
//
//  Created by Xavier De Koninck on 12/10/2017.
//  Copyright © 2017 PagesJaunes. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

final class BingoFooterView: UICollectionReusableView, NibReusable {
  
  @IBOutlet weak var resetButton: UIButton!
  
  let disposeBag = DisposeBag()
}
