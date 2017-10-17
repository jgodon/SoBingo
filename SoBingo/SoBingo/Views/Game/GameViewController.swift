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
  
  let headerSize: CGFloat = 140
  
  let disposeBag = DisposeBag()
  
  var viewModel: GameViewModelType!
  var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Void, BingoCellViewModelType>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    register()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.resetWords.execute(())
  }
  
  private func register() {
    
    collectionView.register(supplementaryViewType: BingoHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    collectionView.register(cellType: BingoCell.self)
    collectionView.register(supplementaryViewType: BingoFooterView.self, ofKind: UICollectionElementKindSectionFooter)
  }
  
  private func setup() {
    
    collectionView.delegate = self
    
    dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, BingoCellViewModelType>>(configureCell:  { ds, cv, ip, viewModel in
      let cell: BingoCell = cv.dequeueReusableCell(for: ip, cellType: BingoCell.self)
      cell.setup(with: viewModel, andIndex: ip.row)
      return cell
    }, configureSupplementaryView: { [weak self] ds, cv, s, ip in
      
      if s == UICollectionElementKindSectionHeader {
        return cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: ip, viewType: BingoHeaderView.self)
      }
      else {
        let footer: BingoFooterView = cv.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: ip, viewType: BingoFooterView.self)
        
        if let viewModel = self?.viewModel {
          footer.resetButton.rx.tap
            .bind(to: viewModel.resetWords.inputs)
            .disposed(by: footer.disposeBag)
        }
        
        return footer
      }
    })
    
    viewModel.words
      .map({ [SectionModel(model: (), items: $0)] })
      .drive(collectionView.rx.items(dataSource: dataSource!))
      .disposed(by: disposeBag)
  }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.bounds.width - (16)) / 2, height: ((collectionView.bounds.height - (16 * 2)) - (headerSize * 2)) / CGFloat(viewModel.nbWords / 2) )
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: headerSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: headerSize)
  }
}
