//
//  LocationCell.swift
//  UberClone
//
//  Created by Apple on 4.06.2021.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

class LocationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var place: GMSPlace? {
        didSet {
            configure()
        }
    }
    
    let pinImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "pinicon").withRenderingMode(.alwaysOriginal))
        iv.setDimensions(height: 32, width: 32)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "Kadıköy Sahili",pColor: #colorLiteral(red: 0.04322652284, green: 0.04322652284, blue: 0.04322652284, alpha: 1), fontName: "HelveticaNeue-Medium",fontSize: 14)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "Rasimpaşa, Kadıköy/İstanbul, Türkiye",pColor: .darkGray, fontName: "HelveticaNeue",fontSize: 13)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(pinImage)
        pinImage.anchor(left: leftAnchor, paddingLeft: 16)
        pinImage.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: pinImage.rightAnchor, paddingLeft: 9)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configure() {
        guard let place = self.place else { return }
        let viewModel = LocationViewModel(place: place)
        titleLabel.text = viewModel.name
        addressLabel.text = viewModel.adress
    }
    
}
