//
//  UnassignedJobsViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 6/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class UnassignedJobsViewController: UIViewController {

    var core = App.sharedCore
    var flowLayout = AppointmentFlowLayout()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dataSource: UnassignedDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(AppointmentCell.nib(), forCellWithReuseIdentifier: AppointmentCell.reuseIdentifier)
        guard let area = core.state.userState.currentArea else { return }
        core.fire(command: LoadUnassignedAppointmentsForArea(area: area, startDate: nil))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

}


// MARK: - Subscriber

extension UnassignedJobsViewController: Subscriber {

    func update(with state: AppState) {
        let currentArea = state.queueState.realAreas.filter { $0.id == state.userState.currentUser?.defaultAreaId! }.first
        dataSource.appointments = currentArea?.unassignedAppointments ?? []
        collectionView.reloadData()
    }

}
