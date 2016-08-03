//
//  ViewController.swift
//  MapaX
//
//  Created by Mario E Salvatierra V on 8/2/16.
//  Copyright © 2016 Dunas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapaView: MKMapView!
    var ultimaPosicion: CLLocation?
    var IntervalosAcumulados = 0.0
    var startLocation: CLLocation!
    
    @IBAction func onSegment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("zero")
            mapaView.mapType = .Standard
        }
        else if sender.selectedSegmentIndex == 1 {
            print("uno")
            mapaView.mapType = .Satellite
        }
        else if sender.selectedSegmentIndex == 2 {
            print("hybrid")
            mapaView.mapType = .Hybrid
        } else {
            mapaView.userTrackingMode = .Follow
        }
        
    }
    let manejador = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        //manejador.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manejador.requestWhenInUseAuthorization()
        
        //punto.latitude = 19.52748
        // punto.latitude = -96.92315
        // let punto = CLLocationCoordinate2DMake(19.52748, -96.92315)
        //mapaView.setCenterCoordinate(punto, animated: true)
        
        mapaView.userTrackingMode = .Follow
        ultimaPosicion = manejador.location
        startLocation = nil
//        let lat = manejador.location?.coordinate.latitude
//        let lon = manejador.location?.coordinate.longitude
//        print("lat mane\(lat)")
//        posicionInicial = CLLocation(latitude: lat!, longitude: lon!)
       // posicionInicial = manejador.location
    }

    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapaView.showsUserLocation = true
            
        } else {
            manejador.stopUpdatingHeading()
            mapaView.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.last
        }
        
        if let intervalFromlast = ultimaPosicion?.distanceFromLocation(locations.last!) {
            if intervalFromlast >= 50 {
                print("more than 50 m is = \(intervalFromlast)")
                ultimaPosicion = locations.last
                
                let latitudLast = locations.last?.coordinate.latitude
                let longitudLast = locations.last?.coordinate.longitude
                let punto = CLLocationCoordinate2D(latitude: latitudLast! , longitude: longitudLast!)
                
                let pin = MKPointAnnotation()
            
                let lonDouble = Double(longitudLast!)
                let latDouble = Double(latitudLast!)
                let lonTitulo = String(format: "%4.4f", lonDouble)
                let latTitulo = String(format: "%4.4f", latDouble)
                pin.title = "Lat: \(latTitulo), Long: \(lonTitulo)"
                
                if intervalFromlast <=  100 {
                    IntervalosAcumulados += intervalFromlast
                }
                let subtituloDouble = Double(IntervalosAcumulados)
                let subtitulo = String(format: "%9.1f", subtituloDouble)
                pin.subtitle = "Distancia Recorrida: \(subtitulo)"
                pin.coordinate = punto
                mapaView.addAnnotation(pin)
                let dist_fromstart = startLocation.distanceFromLocation(locations.last!)
                print("distancia entre startLocation and last one \(dist_fromstart)")
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error porque = \(error.localizedFailureReason)")
    }
}



