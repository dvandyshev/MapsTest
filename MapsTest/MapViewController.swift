//
//  MapViewController.swift
//  MapsTest
//
//  Created by Dmitry Vandyshev on 30.03.2021.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var locationManager: CLLocationManager?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    let realm = try! Realm()
    var isOnMonitoring: Bool = false {
        didSet {
            updateLocationTitle()
        }
    }
    @IBOutlet weak var locationBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera        
    }
    
    func addMarker(_ coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        mapView.animate(toLocation: coordinate)
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func savePath(routePath: GMSMutablePath?) {
        clearOldPaths()
        
        guard let routePath = routePath else {
            return
        }
        
        let path = List<UserLocation>()
        
        for index in 0..<routePath.count() {
            let coordinate: CLLocationCoordinate2D = routePath.coordinate(at: index)
            let location = UserLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            path.append(location)
        }
        
        try! realm.write {
            realm.add(path)
        }
    }
    
    func clearOldPaths() {
        let oldPath = realm.objects(UserLocation.self)
        
        try! realm.write {
            realm.delete(oldPath)
        }
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        isOnMonitoring.toggle()
        
        if isOnMonitoring {
            startTracking()
        } else {
            stopTracking()
            savePath(routePath: routePath)
        }
    }
    
    func startTracking() {
        createRoute()
        locationManager?.startUpdatingLocation()
    }
    
    func createRoute() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    func stopTracking() {
        locationManager?.stopUpdatingLocation()
    }
    
    
    func updateLocationTitle() {
        if isOnMonitoring {
            locationBtn.title = "Закончить трек"
        } else {
            locationBtn.title = "Новый трек"
        }
    }
    
    
    @IBAction func showOldPath(_ sender: Any) {
        if isOnMonitoring {
            isOnMonitoring.toggle()
            stopTracking()
        }
        
        let oldPath = realm.objects(UserLocation.self)
        
        let paths = oldPath.map {
            CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
        }
        
        createRoute()
        
        guard let routePath = routePath else {
            return
        }
        
        paths.forEach { coordinate in
            routePath.add(coordinate)
            route?.path = routePath
        }
        
        let rect = GMSPolyline(path: routePath)
        rect.map = mapView
        
        let bounds = GMSCoordinateBounds(path: routePath)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }       
        if isOnMonitoring {
            routePath?.add(location.coordinate)
            route?.path = routePath
            let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
            mapView.animate(to: position)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
