//
//  QuakeDetailView.swift
//  Quakes
//
//  Created by Paul Solt on 7/11/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

// TODO: Create the Quake class
// TODO: Add the QuakeDetailView to the target (Identity Inspector) to get it to build
class QuakeDetailView: UIView {
    
    // MARK: - Properties
    var quake: Quake? {
        didSet {
            updateSubviews()
        }
    }
    
    private let magnitudeLabel = UILabel()
    private let dateLabel = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    private var formatter = Formatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        latitudeLabel.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
        
        let placeDateStackView = UIStackView(arrangedSubviews: [magnitudeLabel, dateLabel])
        placeDateStackView.spacing = UIStackView.spacingUseSystem
        let latLonStackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        latLonStackView.spacing = UIStackView.spacingUseSystem
        let mainStackView = UIStackView(arrangedSubviews: [placeDateStackView, latLonStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func updateSubviews() {
        guard let quake = quake else { return }
        if let magnitude = quake.magnitude {
            magnitudeLabel.text = String(magnitude) + " magnitude"
        }else{
            magnitudeLabel.text = "Magnitude: N/A"
        }
        
        dateLabel.text = formatter.dateFormatter.string(from: quake.time)
        latitudeLabel.text = "Lat: " + formatter.latLonFormatter.string(from: quake.latitude as NSNumber)!
        longitudeLabel.text = "Lon: " + formatter.latLonFormatter.string(from: quake.longitude as NSNumber)!
    }
}
