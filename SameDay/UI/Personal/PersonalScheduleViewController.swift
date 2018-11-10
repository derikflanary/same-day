//
//  PersonalScheduleViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 5/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import JTAppleCalendar

class PersonalScheduleViewController: UIViewController, Mappable {

    var core = App.sharedCore
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView?
    var zoomLevel: Float = 12.0
    var addedMarkers = [GMSMarker]()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    lazy var monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter
    }()


    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var tableViewDataSource: PersonalScheduleDataSource!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet var emptyStateView: UIView!


    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap(for: topView)
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.theme
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
        tableViewDataSource.appointments = core.state.personalScheduleState.appointmentsOfSelectedDate
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        addMarkersToMap(from: core.state.personalScheduleState.appointmentsOfSelectedDate)
        refreshControl.endRefreshing()
    }

    @IBAction func profileTapped(_ sender: Any) {

    }
    
}


// MARK: - Calendar data source

extension PersonalScheduleViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale


        let startDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 1,
                                                 calendar: Calendar.current,
                                                 generateInDates: .off,
                                                 generateOutDates: .off,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }

}


// MARK: - Calendar delegate

extension PersonalScheduleViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableCalendarCell(for: indexPath) as CalendarCell
        cell.configure(with: date, cellState: cellState, datesWithAppointments: core.state.personalScheduleState.datesWithAppointments, selectedDate: core.state.personalScheduleState.selectedDate)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        var monthDate = Date()
        if let date = visibleDates.monthDates.first?.date {
            monthDate = date
        }
        let nameOfMonth = monthFormatter.string(from: monthDate)
        monthLabel.text = nameOfMonth
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dayLabel.text = cellState.text
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        core.fire(event: Selected(item: date))
        calendarView.reloadData()
        tableViewDataSource.selectedAppointment = nil
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        calendarView.reloadData()
    }

}


// MARK: - Location delegate

extension PersonalScheduleViewController: CLLocationManagerDelegate {

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        handleLocationManagerDidUpLocations(with: manager, locations: locations)
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView?.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

}


// MARK: - Mapview delegate

extension PersonalScheduleViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        guard let mapsURL = URL(string:"comgooglemaps://"), let directionsURL = URL(string: "comgooglemaps://?saddr=&daddr=\(Float(marker.position.latitude)),\(Float(marker.position.longitude))&directionsmode=driving") else { return }
        if UIApplication.shared.canOpenURL(mapsURL) {
            UIApplication.shared.open(directionsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let appointment = core.state.personalScheduleState.appointmentsOfSelectedDate.appointment(for: marker) else { return false }
        tableViewDataSource.selectedAppointment = appointment
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
        return false
    }

}


// MARK: - Tableview delegate

extension PersonalScheduleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appointment = tableViewDataSource.appointments[indexPath.row]
        guard let coordinate = appointment.invoice?.account.coordinates else { return }
        mapView?.animate(to: GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        tableViewDataSource.selectedAppointment = appointment
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }

}


// MARK: - Private functions

private extension PersonalScheduleViewController {

    func addMarkersToMap(from appointments: [Appointment]) {
        
        for marker in addedMarkers {
            marker.map = nil
        }
        addedMarkers.removeAll()
        let markers: [GMSMarker] = appointments.compactMap {
            guard let coordinate = $0.invoice?.account.coordinates else { return nil }
            let marker =  GMSMarker(position: coordinate)
            marker.icon = GMSMarker.markerImage(with: UIColor.secondary)
            marker.title = $0.invoice?.account.displayName ?? $0.areaName
            marker.snippet = $0.displayStartTime
            return marker
        }
        for marker in markers {
            guard !addedMarkers.contains(marker) else { continue }
            marker.map = mapView
            addedMarkers.append(marker)
        }
    }

}


// MARK: - Subscriber

extension PersonalScheduleViewController: Subscriber {

    func update(with state: AppState) {
        tableViewDataSource.appointments = state.personalScheduleState.appointmentsOfSelectedDate
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        addMarkersToMap(from: state.personalScheduleState.appointmentsOfSelectedDate)
        if tableViewDataSource.appointments.isEmpty {
            tableView.backgroundView = emptyStateView
        } else {
            tableView.backgroundView = nil
        }
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
