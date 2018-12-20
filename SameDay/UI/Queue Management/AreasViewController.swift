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

class AreasViewController: UIViewController, Mappable {

    enum AnimationDirection {
        case into
        case out
    }

    enum MapState {
        case normal
        case move(area: Area)
    }

    @IBOutlet var newAreaView: NewAreaView!
    @IBOutlet var areaInfoWindow: AreaInfoWindow!
    
    var core = App.sharedCore
    private var currentLocation: CLLocation?
    internal var locationManager = CLLocationManager()
    internal var mapView: GMSMapView?
    internal var zoomLevel: Float = 10.0
    private var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    private var areas = [Area]()
    private var addedMarkers = [GMSMarker]()
    private var temporaryMarker: GMSMarker?
    private var selectedMarker: GMSMarker?
    private var mapState = MapState.normal

    private var markers: [GMSMarker] {
        var marks = [GMSMarker]()
        for area in areas {
//            let marker = GMSMarker(position: area.coordinate)
//            marker.designed(with: area.name)
//            marks.append(marker)
        }
        return marks
    }

    private let dropDownHiddenY: CGFloat = -100
    private let dropDownVisibleY: CGFloat = 100
    private let dropDownMargin: CGFloat = 16


    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap(for: view)
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

extension AreasViewController: CLLocationManagerDelegate {

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


// MARK: - MapView delegate

extension AreasViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        guard case .normal = mapState else { return }
        guard temporaryMarker == nil else { return }
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult() {
                self.newAreaView.frame = CGRect(x: self.dropDownMargin, y: self.dropDownHiddenY, width: self.view.frame.width - (self.dropDownMargin * 2), height: NewAreaView.height)
                self.newAreaView.update(with: address.locality, coordinate: coordinate)
                self.view.addSubview(self.newAreaView)
                self.temporaryMarker = GMSMarker(position: coordinate)
                self.temporaryMarker?.map = mapView
                self.temporaryMarker?.designed()
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
//        guard let area = areas.area(for: marker) else { return false }
//        areaInfoWindow.removeFromSuperview()
//        areaInfoWindow.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - (self.dropDownMargin * 2), height: AreaInfoWindow.height)
//        let markerPosition = mapView.projection.point(for: marker.position)
//        areaInfoWindow.center = CGPoint(x: markerPosition.x, y: markerPosition.y - AreaInfoWindow.height)
//        areaInfoWindow.area = area
//        areaInfoWindow.completion = {
//            self.areaInfoWindow.removeFromSuperview()
//        }
//        view.addSubview(areaInfoWindow)
//        selectedMarker = marker
        return false
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard let selectedMarker = selectedMarker else { return }
        let markerPosition = mapView.projection.point(for: selectedMarker.position)
        areaInfoWindow.center = CGPoint(x: markerPosition.x, y: markerPosition.y - AreaInfoWindow.height)
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        areaInfoWindow.removeFromSuperview()
    }

    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
//        guard let areaMoving = areas.area(for: marker) else { return }
//        marker.designedForDragging()
//        mapState = .move(area: areaMoving)
    }

    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        guard case let MapState.move(movedArea) = mapState else { return }
//        movedArea.coordinate = marker.position
        core.fire(event: Updated(item: movedArea))
        mapState = .normal
    }

}


// MARK: - Private functions

private extension AreasViewController {

    func addMarkersToMap() {
        for marker in addedMarkers {
            marker.map = nil
        }
        addedMarkers.removeAll()
        for marker in markers {
            guard !addedMarkers.contains(marker) else { continue }
            marker.map = mapView
            marker.isDraggable = true
            addedMarkers.append(marker)
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


// MARK: - Subscriber

extension AreasViewController: Subscriber {

    func update(with state: AppState) {
        addMarkersToMap()
    }
    
}
