//
//  ViewController.swift
//  MapkitExercise
//
//  Created by Hyung Seo Han on 2022/07/15.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    //위치와 관련된 매니저 설정
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationConfiguration()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func locationConfiguration(){
        locationManager.delegate = self
        let status = locationManager.authorizationStatus
        if status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginToTrackUserLocation(with: locationManager)
        }
    }
    
    private func beginToTrackUserLocation(with manager: CLLocationManager){
        mapView.showsUserLocation = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    private func zoomToCurrentUserLocation(with coordinates: CLLocationCoordinate2D){
        let mapRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapRegion, animated: false)
    }
    
    @IBAction func findCurrentLocation(_ sender: Any) {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            zoomToCurrentUserLocation(with: currentLocation!)
        }
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("User location Updated")
        guard let location = locations.first else{ return }
        if currentLocation == nil{
            zoomToCurrentUserLocation(with: location.coordinate)
        }
        currentLocation = location.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        print("Auth Changed to",manager.authorizationStatus.rawValue)
        let status = manager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginToTrackUserLocation(with: manager)
        }
    }
    
}
