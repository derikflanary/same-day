//
//  AppointmentDetailViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 11/12/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class AppointmentDetailViewController: UIViewController {

    var core = App.sharedCore
    var addressTapGesture = UITapGestureRecognizer()
    var appointment: Appointment?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var windowLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var denyButton: RoundedButton!
    @IBOutlet weak var acceptButton: RoundedButton!
    @IBOutlet weak var completeButton: RoundedButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        addressTapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        addressLabel.addGestureRecognizer(addressTapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    @objc func addressTapped() {
        guard let coordinates = appointment?.coordinates else { return }
        if let url = URL(string:"comgooglemaps://?center=\(coordinates.latitude),\(coordinates.longitude)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://");
        }
    }

    @IBAction func denyTapped() {

    }

    @IBAction func acceptTapped() {

    }

    @IBAction func completeTapped() {
        
    }

}


// MARK: - Subscriber

extension AppointmentDetailViewController: Subscriber {

    func update(with state: AppState) {
        guard let appointment = state.appointmentState.selectedAppointment else { return }
        self.appointment = appointment
        nameLabel.text = appointment.displayName
        addressLabel.text = appointment.addressString
        dateLabel.text = appointment.displayStartDateAndTime ?? appointment.date.weekDayMonthDayString()
        windowLabel.text = appointment.displayEndDateAndTime
        phoneLabel.text = appointment.phone.asPhoneNumber()
        areaLabel.text = appointment.areaName
        switch state.appointmentState.appointmentSourceType {
        case .potential:
            acceptButton.isHidden = false
            denyButton.isHidden = false
            completeButton.isHidden = true
        case .personalSchedule:
            acceptButton.isHidden = true
            denyButton.isHidden = true
            completeButton.isHidden = false
        }
    }

}
