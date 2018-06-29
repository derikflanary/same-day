//
//  ColumnFlowLayout.swift
//  SameDay
//
//  Created by Derik Flanary on 6/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class AppointmentFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        self.itemSize = CGSize(width: collectionView.bounds.insetBy(dx: collectionView.layoutMargins.left, dy: collectionView.layoutMargins.top).size.width, height: AppointmentCell.height)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea

    }
}
