//
//  AddAreaViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class AddAreaViewController: UIViewController {

    enum AnimationDirection {
        case into
        case out
    }

    @IBOutlet var newAreaView: NewAreaView!

    var core = App.sharedCore
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    var zoomLevel: Float = 10.0
    var areas = [Area]()
    var addedMarkers = [GMSMarker]()
    var temporaryMarker: GMSMarker?
    var markers: [GMSMarker] {
        var marks = [GMSMarker]()
        for area in areas {
            let marker = GMSMarker(position: area.coordinate)
            marker.title = area.name
            marker.icon = #imageLiteral(resourceName: "map-pin")
            marks.append(marker)
        }
        return marks
    }

    private let dropDownHiddenY: CGFloat = -100
    private let dropDownVisibleY: CGFloat = 100
    private let dropDownMargin: CGFloat = 16


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        let location = CLLocation(latitude: CLLocationDegrees(exactly: 40.7608)!, longitude: CLLocationDegrees(exactly: 111.8910)!)
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.isHidden = true
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


// MARK: - Location delegate

extension AddAreaViewController: CLLocationManagerDelegate {

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
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


// MARK: - MapView delegate
extension AddAreaViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        guard temporaryMarker == nil else { return }
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult() {
                self.newAreaView.frame = CGRect(x: self.dropDownMargin, y: self.dropDownHiddenY, width: self.view.frame.width - (self.dropDownMargin * 2), height: NewAreaView.height)
                self.newAreaView.update(with: address.locality, coordinate: coordinate)
                self.view.addSubview(self.newAreaView)
                self.temporaryMarker = GMSMarker(position: coordinate)
                self.temporaryMarker?.map = mapView
                self.temporaryMarker?.icon = #imageLiteral(resourceName: "map-pin")
                self.animateNewAreaView(.into)

                self.newAreaView.completion = {
                    self.temporaryMarker?.map = nil
                    self.temporaryMarker = nil
                    self.animateNewAreaView(.out)
                }
            }
        }
    }

    func animateNewAreaView(_ direction: AnimationDirection) {
        var yPosition: CGFloat = 0
        switch direction {
        case .into:
            yPosition = dropDownVisibleY
        case .out:
            yPosition = dropDownHiddenY
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.newAreaView.frame = CGRect(x: self.dropDownMargin, y: yPosition, width: self.view.frame.width - (self.dropDownMargin * 2), height: NewAreaView.height)
        }) { _ in
            if case .out = direction {
                self.newAreaView.removeFromSuperview()
            }
        }
    }

}

private extension AddAreaViewController {

    func addMarkersToMap() {
        for marker in markers {
            guard !addedMarkers.contains(marker) else { continue }
            marker.map = mapView
            addedMarkers.append(marker)
        }
    }

}


// MARK: - Subscriber

extension AddAreaViewController: Subscriber {

    func update(with state: AppState) {
        areas = state.queueState.areas
        addMarkersToMap()
    }
    
}
