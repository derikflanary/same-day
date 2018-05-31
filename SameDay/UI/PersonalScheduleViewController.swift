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
    var zoomLevel: Float = 8.0
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap(for: topView)
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


// MARK: - Calendar data source

extension PersonalScheduleViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let params = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return params
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 1,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }

}


// MARK: - Calendar delegate

extension PersonalScheduleViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCalendarCell(for: indexPath) as CalendarCell
        cell.dayLabel.text = cellState.text
        return cell
    }


    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dayLabel.text = cellState.text
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


// MARK: - Private functions

private extension PersonalScheduleViewController { }


// MARK: - Subscriber

extension PersonalScheduleViewController: Subscriber {

    func update(with state: AppState) {

    }

}
