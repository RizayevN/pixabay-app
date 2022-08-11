//
//  CollectionViewFlowLayout.swift
//  PixabayApp
//
//  Created by Rizayev Nematzhon on 02.04.2022.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {

  override func prepare() {
    super.prepare()

    guard let collection = collectionView else {
      return
    }
    scrollDirection = .horizontal

    minimumInteritemSpacing = 8
    minimumLineSpacing = 10
    scrollDirection = .vertical

    let width = (collection.frame.width - 8) / 2

    itemSize = .init(width: width, height: 200)
  }
}
