//
//  Mappable.swift
//  SameDay
//
//  Created by Derik Flanary on 5/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation

typealias MapDelegate = GMSMapViewDelegate & CLLocationManagerDelegate

protocol Mappable: MapDelegate {
    var mapView: GMSMapView? { get set }
    var locationManager: CLLocationManager { get set }
    var zoomLevel: Float { get set }
}

extension Mappable where Self: UIViewController {

    func configureMap(for mapHolderView: UIView) {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        let location = CLLocation(latitude: CLLocationDegrees(exactly: 40.7608)!, longitude: CLLocationDegrees(exactly: 111.8910)!)
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapHolderView.bounds, camera: camera)
        guard let mapView = mapView else { return }
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.tiltGestures = false
        mapView.settings.indoorPicker = false
        mapView.delegate = self
        mapHolderView.addSubview(mapView)
        mapView.isHidden = true
    }

    func handleLocationManagerDidUpLocations(with manager: CLLocationManager, locations: [CLLocation]) {
        guard let location = locations.last, let mapView = mapView, mapView.isHidden else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView.isHidden = false
        mapView.camera = camera
        mapView.animate(to: camera)
    }

}
