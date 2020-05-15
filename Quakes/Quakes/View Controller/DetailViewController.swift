//
//  DetailViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/6/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit
import GaugeKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var depthLabel: UILabel!
    
    //MARK: - Properties
    var selectedQuake: Quake? {
        didSet{
            setupLabels()
        }
    }
    
    private var formatter = Formatter()
    
    var gauge = Gauge()

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
    }
    
    //MARK: - Setup View
    private func setupLabels(){
        if let quake = selectedQuake{
             
            //guard let lat = formatter.latLonFormatter.string(from: quake.latitude as NSNumber), let lon = formatter.latLonFormatter.string(from: quake.longitude as NSNumber) else { return }
            
            let date = formatter.dateFormatter.string(from: quake.time)
            
            //placeLabel.text = quake.place
            //placeLabel.text = quake.place
            dateLabel.text = date
            depthLabel.text = "\(quake.depth)km"
            latitudeLabel.text = String(quake.latitude)
            longitudeLabel.text = String(quake.longitude)

            if let magnitude = quake.magnitude {
                magnitudeLabel.text = "\(magnitude)"
                
                if magnitude >= 5 {
                    magnitudeLabel.textColor = .red
                } else if magnitude >= 3 && magnitude < 5 {
                    magnitudeLabel.textColor = .yellow
                }
                
            }else{
                magnitudeLabel.text = "N/A"
            }
            
            locateOnMap(for: quake.coordinate)
            createAnotation(for: quake.coordinate, quake: quake)
        }
    }
    
    private func locateOnMap(for location: CLLocationCoordinate2D) {
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        
        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func createAnotation(for location: CLLocationCoordinate2D, quake: Quake)  {
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
        anotation.title = quake.title
        
        mapView.addAnnotation(anotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebView"{
            guard let webVC = segue.destination as? WebViewController else {
               return
            }
            webVC.urlString = selectedQuake?.url
        }
    }
}

