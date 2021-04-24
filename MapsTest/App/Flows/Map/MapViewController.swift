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
    var locationManager = LocationManager.instance
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    let realm = try! Realm()
    var marker:GMSMarker?
    var avatar: UIImage?
    var isOnMonitoring: Bool = false {
        didSet {
            updateLocationTitle()
        }
    }
    
    lazy var locationBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = UIImage(systemName: "play")
        btn.action = #selector(updateLocation)
        btn.target = self
        return btn
    }()
    
    lazy var oldPathBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = UIImage(systemName: "arrow.clockwise")
        btn.action = #selector(showOldPath)
        btn.target = self
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMap()
        configureLocationManager()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL {
            let fileURL = directory.appendingPathComponent("avatar.png")
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = try UIImage(data: imageData)
                let targetSize = CGSize(width: 30, height: 30)

                avatar = resizeImage(image: image, targetSize: targetSize)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
    func configureUI() {
        navigationItem.rightBarButtonItems = [locationBtn, oldPathBtn]
        navigationItem.title = "Карта"
    }
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera        
    }
    
    func addMarker(_ coordinate: CLLocationCoordinate2D) {
        if marker == nil {
            marker = GMSMarker(position: coordinate)
            marker?.map = mapView
            
            if let avatar = avatar {
                marker?.icon = avatar
            }
        } else {
            marker?.position = coordinate
        }
    }
    
    func configureLocationManager() {
        locationManager.location.asObservable().bind { [weak self] location in
            guard let location = location, let self = self else { return }
            if self.isOnMonitoring {
                self.routePath?.add(location.coordinate)
                self.route?.path = self.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self.mapView.animate(to: position)
                self.addMarker(location.coordinate)
            }
        }
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
    
    @objc func updateLocation(_ sender: Any) {
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
        locationManager.startUpdatingLocation()
    }
    
    func createRoute() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func updateLocationTitle() {
        if isOnMonitoring {
            locationBtn.image = UIImage(systemName: "pause")
        } else {
            locationBtn.image = UIImage(systemName: "play")
        }
    }
    
    @objc func showOldPath(_ sender: Any) {
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
