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
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    @IBOutlet var tableViewDataSource: PersonalScheduleDataSource!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!


    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap(for: topView)
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.themeColor
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
        tableViewDataSource.jobs = core.state.personalScheduleState.jobsOfSelectedDate
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        addMarkersToMap(from: core.state.personalScheduleState.jobsOfSelectedDate.map { $0.coordinate } )
        refreshControl.endRefreshing()
    }

}


// MARK: - Calendar data source

extension PersonalScheduleViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        let startDate = Date()
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
        cell.dayLabel.text = cellState.text
        cell.weekDayLabel.text = date.dayOfWeek()
        if cellState.dateBelongsTo == .thisMonth {
            cell.dayLabel.textColor = UIColor.blackOne
            cell.weekDayLabel.textColor = UIColor.blackOne
        } else {
            cell.dayLabel.textColor = UIColor.grayTwo
            cell.weekDayLabel.textColor = UIColor.blackOne
        }
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            cell.dayLabel.textColor = UIColor.destructiveRed
            cell.weekDayLabel.textColor = UIColor.destructiveRed
        }
        cell.selectedView.isHidden = !cellState.isSelected
        return cell
    }


    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dayLabel.text = cellState.text
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        cell.selectedView.isHidden = false
        core.fire(event: Selected(item: date))
        tableViewDataSource.selectedIndex = nil
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        cell.selectedView.isHidden = true
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

extension PersonalScheduleViewController: GMSMapViewDelegate { }


// MARK: - Tableview delegate

extension PersonalScheduleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = tableViewDataSource.jobs[indexPath.row]
        mapView?.animate(to: GMSCameraPosition(target: job.coordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        tableViewDataSource.selectedIndex = indexPath
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }

}


// MARK: - Private functions

private extension PersonalScheduleViewController {

    func addMarkersToMap(from coordinates: [CLLocationCoordinate2D]) {
        for marker in addedMarkers {
            marker.map = nil
        }
        addedMarkers.removeAll()
        let markers: [GMSMarker] = coordinates.map { GMSMarker(position: $0) }
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
        tableViewDataSource.jobs = state.personalScheduleState.jobsOfSelectedDate
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        addMarkersToMap(from: state.personalScheduleState.jobsOfSelectedDate.map { $0.coordinate } )
    }

}

