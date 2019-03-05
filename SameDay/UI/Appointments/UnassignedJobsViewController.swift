//
//  UnassignedJobsViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 6/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import SwiftEntryKit

class UnassignedJobsViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case showAppointmentDetail
    }

    var core = App.sharedCore
    var flowLayout = AppointmentFlowLayout()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dataSource: UnassignedDataSource!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var emptyStateView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(AppointmentCell.nib(), forCellWithReuseIdentifier: AppointmentCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
        guard let currentUserId = core.state.userState.currentUserId else { return }
        core.fire(command: LoadAllUnassignedAppointments(for: currentUserId))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    @objc func handleRefresh() {
        refreshControl.endRefreshing()
        guard let currentUserId = core.state.userState.currentUserId else { return }
        core.fire(command: LoadAllUnassignedAppointments(for: currentUserId))
    }

}


// MARK: - CollectionView delegate

extension UnassignedJobsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appointment = dataSource.appointments[indexPath.row]
        core.fire(event: Selected(item: appointment))
        core.fire(event: Selected(item: AppointmentSourceType.potential))
        performSegueWithIdentifier(.showAppointmentDetail)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.15) {
            cell?.alpha = 0.6
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.15) {
            cell?.alpha = 1.0
        }
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
        dataSource.appointments = state.queueState.potentialUnassignedAppointments
        collectionView.reloadData()
        if state.queueState.appointmentsLoaded {
            loadingIndicator.stopAnimating()
            collectionView.backgroundView = dataSource.appointments.isEmpty ? emptyStateView : nil
        } else {
            loadingIndicator.startAnimating()
            collectionView.backgroundView = nil
        }
    }

}
