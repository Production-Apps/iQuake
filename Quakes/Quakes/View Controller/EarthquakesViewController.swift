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
    private var quakeFetcher = QuakeFetcher()
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    private var quakesArray: [Quake]?
    private var selectedAnnotation: Quake?
    private var detailView = QuakeDetailView()
    
    //MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var locationArrowLabel: UIButton!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        mapView.delegate = self
        
        fetchQuakes()
        
        //Create a reusable cell
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
    }
    
    //MARK: - Setup Methods
    private func setupUI(){
        searchButton.isEnabled = false
        locationArrowLabel.layer.cornerRadius = 5
    }
    
    private func fetchQuakes()  {
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error {
                print("Error fetching quakes: \(error)")
                return
            }
            
            guard let quakes = quakes else { return }
            self.quakesArray = quakes
            
            DispatchQueue.main.async {
                self.searchButton.isEnabled = true
                //Create annotations
                self.mapView.addAnnotations(quakes)
            }
            self.currentLocation()
        }
    }
    
    private func currentLocation(manualRequest:Bool = false) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        if let currentLocation = self.locationManager.location?.coordinate {
            self.locateOnMap(for: currentLocation)
        }else{
            if manualRequest{
                locationAlert()
            }
        }
    }
    
    private func locationAlert() {
        let alertController = UIAlertController.init(title: "Current location not available",message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { (action) in
            
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
    
    private func locateOnMap(for location: CLLocationCoordinate2D) {
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        
        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        
        lookUpCurrentLocation { locationName in
            DispatchQueue.main.async {
                self.navigationItem.title = locationName?.locality
            }
            
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    private func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    print("Could not locate")
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            print("Could not locate2")
            completionHandler(nil)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        currentLocation(manualRequest: true)
    }
    
    @IBAction func dismissViewButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue"{
            
            guard let searchVC = segue.destination as? SearchTableViewController else {
                print("Cannot downcast SearchVC")
                return
            }
            
            searchVC.quakesArray = self.quakesArray ?? []
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
