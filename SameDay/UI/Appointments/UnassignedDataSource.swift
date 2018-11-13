//
//  UnassignedDataSource.swift
//  SameDay
//
//  Created by Derik Flanary on 6/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class UnassignedDataSource: NSObject, UICollectionViewDataSource {

    var appointments = [Appointment]()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as AppointmentCell
        let appointment = appointments[indexPath.row]
        cell.configure(with: appointment)
        return cell
    }

}
