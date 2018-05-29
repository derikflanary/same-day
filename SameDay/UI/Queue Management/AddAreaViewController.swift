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
    @IBOutlet var areaInfoWindow: AreaInfoWindow!
    
    var core = App.sharedCore
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var mapView: GMSMapView!
    private var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    private var zoomLevel: Float = 10.0
    private var areas = [Area]()
    private var addedMarkers = [GMSMarker]()
    private var temporaryMarker: GMSMarker?
    private var selectedMarker: GMSMarker?

    private var markers: [GMSMarker] {
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


    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
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

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let area = area(for: marker) else { return false }
        areaInfoWindow.removeFromSuperview()
        areaInfoWindow.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - (self.dropDownMargin * 2), height: AreaInfoWindow.height)
        areaInfoWindow.center = mapView.projection.point(for: marker.position)
        areaInfoWindow.center.y += -AreaInfoWindow.height
        areaInfoWindow.area = area

        view.addSubview(areaInfoWindow)
        selectedMarker = marker
        return false
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard let selectedMarker = selectedMarker else { return }
        areaInfoWindow.center = mapView.projection.point(for: selectedMarker.position)
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        areaInfoWindow.removeFromSuperview()
    }

}


// MARK: - Private functions

private extension AddAreaViewController {

    func configureMap() {
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

    func addMarkersToMap() {
        for marker in markers {
            guard !addedMarkers.contains(marker) else { continue }
            marker.map = mapView
            addedMarkers.append(marker)
        }
    }

    func area(for marker: GMSMarker) -> Area? {
        return areas.filter { $0.coordinate.latitude == marker.position.latitude && $0.coordinate.longitude == marker.position.longitude }.first
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


// MARK: - Subscriber

extension AddAreaViewController: Subscriber {

    func update(with state: AppState) {
        areas = state.queueState.areas
        addMarkersToMap()
    }
    
}

