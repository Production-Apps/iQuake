//
//  SearchTableTableViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/4/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
    
    //MARK: - Properties
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    private var quakeFetcher = QuakeFetcher()
    private var quakesArray: [Quake]?
    private var selectedAnnotation: Quake?
    private var detailView = QuakeDetailView()
    private let defaults = UserDefaults.standard
    
    //MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var locationArrowLabel: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        mapView.delegate = self
        
        fetchQuakes()
        
        //Create a reusable Annotations
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
    }
    
    //MARK: - Private Methods
    
    private func setupUI(){
        
        locationArrowLabel.isHidden = !self.defaults.bool(forKey: "LocationPref")
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        searchButton.isEnabled = false
        locationArrowLabel.layer.cornerRadius = 5
    }
    
    private func locationAlert() {
        let alertController = UIAlertController.init(title: "Location not available.",message: "GPS access is restricted. In order to use your location, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(settingsURL){
                
                UIApplication.shared.open(settingsURL, completionHandler: nil)
            }
        }
        let canceAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(canceAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func networkAlert() {
        
        let alertController = UIAlertController(title: "Network error", message: "The internet connection appears to be offline.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func fetchQuakes()  {
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let _ = error {
                self.networkAlert()
                return
            }
            
            guard let quakes = quakes else { return }
            
            self.quakesArray = quakes
            
            DispatchQueue.main.async {
                self.searchButton.isEnabled = true
                self.loadingIndicator.stopAnimating()
                //Create annotations
                self.mapView.addAnnotations(quakes)
            }
            //Read from user defaults if user want to use his location
            let useMyLocation = self.defaults.bool(forKey: "LocationPref")
            if useMyLocation{
                self.currentLocation()
            }
        }
    }
    
    private func currentLocation(manualRequest:Bool = false) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        if let currentLocation = self.locationManager.location?.coordinate {
            self.locateOnMap(for: currentLocation)
            locationManager.stopUpdatingLocation()
        }else{
            if manualRequest{
                locationAlert()
            }
        }
    }
    
    private func locateOnMap(for location: CLLocationCoordinate2D) {
        
        let userPrefZoom = CLLocationDegrees(defaults.float(forKey: "LocationZoom"))
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: userPrefZoom, longitudeDelta: userPrefZoom)
        
        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        currentLocation(manualRequest: true)
    }
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue"{
            
            guard let searchVC = segue.destination as? SearchTableViewController else { return }
            
            searchVC.quakesArray = self.quakesArray ?? []
        }else if segue.identifier == "SettingsSegue"{
            guard let settingsVC = segue.destination as? SettingsTableViewController else { return }
            settingsVC.delegate = self
        }
    }
}

//MARK: - MKMapViewDelegate

extension EarthquakesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Get quake
        guard let quake = annotation as? Quake else {
            fatalError("Only supporting quakes")
        }
        
        //Get anotationview
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView", for: quake) as? MKMarkerAnnotationView else {
            fatalError("Missing register map anotation")
        }
        
        annotationView.glyphImage = UIImage(named: "radar")
        
        //Change the color of the marker base on the severaty of the quake
        if let magnitude = quake.magnitude {
            if magnitude >= 5 {
                annotationView.markerTintColor = .red
            } else if magnitude >= 3 && magnitude < 5 {
                annotationView.markerTintColor = .orange
            }else{
                annotationView.markerTintColor = .yellow
            }
        }else{
            //If there is no magnitude set to white
            annotationView.markerTintColor = .white
        }
        
        //New view when we tap on the pin showing details
        annotationView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}

extension EarthquakesViewController: SettingsManagementDelegate {
    func settingsDidChanged() {
        guard let quakes = quakesArray else {
            return
        }
        self.mapView.removeAnnotations(quakes)
        
        fetchQuakes()
        setupUI()
    }
    
    
}
