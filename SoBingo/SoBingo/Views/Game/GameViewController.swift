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
import RxDataSources

final class GameViewController: UIViewController, StoryboardBased {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var resetButton: UIBarButtonItem!
  
  let headerSize: CGFloat = 150
  
  let disposeBag = DisposeBag()
  
  var viewModel: GameViewModelType!
  let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, BingoCellViewModelType>>(configureCell:  { ds, cv, ip, viewModel in
    let cell: BingoCell = cv.dequeueReusableCell(for: ip, cellType: BingoCell.self)
    cell.setup(with: viewModel)
    return cell
  }, configureSupplementaryView: { ds, cv, s, ip in
    return cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: ip, viewType: BingoHeaderView.self)
  })
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    register()
    setup()
    viewModel.resetWords.execute(())
  }
  
  private func register() {
    
    collectionView.register(supplementaryViewType: BingoHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    collectionView.register(cellType: BingoCell.self)
  }
  
  private func setup() {
    
    collectionView.delegate = self
    
    resetButton.rx.tap
      .bind(to: viewModel.resetWords.inputs)
      .disposed(by: disposeBag)
    
    viewModel.words
      .map({ [SectionModel(model: (), items: $0)] })
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width / 2, height: (collectionView.bounds.height - headerSize) / CGFloat(viewModel.nbWords / 2) )
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: headerSize)
  }
}
