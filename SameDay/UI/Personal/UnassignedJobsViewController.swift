//
//  UnassignedJobsViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 6/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import SwiftEntryKit

class UnassignedJobsViewController: UIViewController {

    var core = App.sharedCore
    var flowLayout = AppointmentFlowLayout()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

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

    @objc func handleRefresh() {
        guard let area = core.state.userState.currentArea else { return }
        core.fire(command: LoadUnassignedAppointmentsForArea(area: area, startDate: nil))
    }

}


// MARK: - CollectionView delegate

extension UnassignedJobsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appointment = dataSource.appointments[indexPath.row]
        showAcceptJobAlert(for: appointment)
//        showAlert(title: appointment.invoice.account.addressString, message: "You have selected this job", image: nil, completion: {
//            self.navigationController?.popViewController(animated: true)
//        } )
    }
}

private extension UnassignedJobsViewController {

    func showAcceptJobAlert(for appointment: Appointment) {
        let alertController = UIAlertController(title: "Accept This Job", message: "Would you like to assign this job to yourself? The job will be added to your schedule.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { action in
            // Call command to accept the appointment.
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
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
