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
    var phoneTapGesture = UITapGestureRecognizer()
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
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var numberOfReceiversLabel: UILabel!
    @IBOutlet weak var receiverTypesLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addressTapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        addressLabel.addGestureRecognizer(addressTapGesture)
        phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneTapped))
        phoneLabel.addGestureRecognizer(phoneTapGesture)
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
        guard let directionsURL = URL(string: "comgooglemaps://?saddr=&daddr=\(Float(coordinates.latitude)),\(Float(coordinates.longitude))&directionsmode=driving") else { return }
        UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
    }
    
    @objc func phoneTapped() {
        guard let appointment = appointment, appointment.employeeId != nil else { return }
        guard let url = URL(string: "tel://\(appointment.phone)") else { return }
        UIApplication.shared.open(url)
    }

    @IBAction func denyTapped() {
        denyButton.isLoading = true
        updateAppointment(with: nil, updateType: .deny)
    }

    @IBAction func acceptTapped() {
        guard let userId = core.state.userState.currentUserId else { return }
        acceptButton.isLoading = true
        updateAppointment(with: userId, updateType: .accept)
    }

    @IBAction func completeTapped() {
        guard let userId = core.state.userState.currentUserId else { return }
        completeButton.isLoading = true
        updateAppointment(with: userId, updateType: .complete)
    }
    
}


// MARK: - Private function

private extension AppointmentDetailViewController {
    
    func updateAppointment(with userId: Int?, updateType: AppointmentUpdateType) {
        guard let appointment = appointment else { return }
        disableButtons()
        core.fire(command: UpdateAppointment(for: userId, appointment: appointment, updateType: updateType, completion: { succeeded, title, message in
            self.completeButton.isLoading = false
            self.enableButtons()
            if succeeded {
                self.showAlert(title: "Succeeded", message: updateType.successMessage, image: nil, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else if let message = message {
                switch updateType {
                case .accept:
                    self.acceptButton.shake()
                case .deny:
                    self.denyButton.shake()
                case .complete:
                    self.completeButton.shake()
                }
                self.showErrorMessage(title, message: message)
            }
        }))
    }
    
    func disableButtons() {
        acceptButton.isEnabled = false
        denyButton.isEnabled = false
        completeButton.isEnabled = false
    }
    
    func enableButtons() {
        acceptButton.isEnabled = true
        acceptButton.isLoading = false
        denyButton.isEnabled = true
        denyButton.isLoading = false
        completeButton.isEnabled = true
        completeButton.isLoading = false
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
        windowLabel.text = appointment.windowString
        areaLabel.text = appointment.areaName
        promotionLabel.text = "Promotion: \(appointment.promotion)"
        numberOfReceiversLabel.text = "Number TVs: \(appointment.numberTvs)"
        receiverTypesLabel.text = "Receivers: \(appointment.receiversString)"
        switch state.appointmentState.appointmentSourceType {
        case .potential:
            acceptButton.isHidden = false
            denyButton.isHidden = true
            completeButton.isHidden = true
            phoneLabel.text = appointment.phone.asPhoneNumber()
        case .personalSchedule:
            if appointment.result == .completed {
                phoneLabel.text = appointment.phone.asPhoneNumber()
                acceptButton.isHidden = true
                denyButton.isHidden = true
                completeButton.isHidden = true
            } else {
                phoneLabel.attributedText = NSAttributedString(string: appointment.phone.asPhoneNumber() ?? "", attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                acceptButton.isHidden = true
                denyButton.isHidden = false
                completeButton.isHidden = false
            }
        }
    }

}
