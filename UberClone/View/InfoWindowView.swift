//
//  InfoWindowView.swift
//  UberClone
//
//  Created by Apple on 13.07.2021.
//

import UIKit

class InfoWindowView: UIView {
    
    let locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    init(frame: CGRect, isStartMarkerIW: Bool, timeLabelText: String, infoWindowText: String) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9968915582, green: 0.9969149232, blue: 0.996902287, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        
        let timeInfoView = UIView()
        
        if isStartMarkerIW {
            timeInfoView.backgroundColor = .black
            addSubview(timeInfoView)
            timeInfoView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, width: 37)
            
            let timeLabel = UILabel()
            timeLabel.defineLabelDetails(pText: "\(timeLabelText)", pColor: .white, fontName: "OpenSans-SemiBold", fontSize: 14)
            
            let secMinHourLabel = UILabel()
            secMinHourLabel.defineLabelDetails(pText: "DK.", pColor: .white, fontName: "OpenSans-Regular", fontSize: 8)
            
            let labelStack = UIStackView(arrangedSubviews: [timeLabel, secMinHourLabel])
            labelStack.axis = .vertical
            labelStack.spacing = -5
            labelStack.alignment = .center
            timeInfoView.addSubview(labelStack)
            labelStack.anchor(top: timeInfoView .topAnchor,bottom: bottomAnchor, paddingTop: 6, paddingBottom: 6)
            labelStack.centerX(inView: timeInfoView)
            
            
            timeLabel.adjustsFontForContentSizeCategory = true
            secMinHourLabel.adjustsFontForContentSizeCategory = true
            
        }
        
        
        locationLabel.defineLabelDetails(pText: "  \(infoWindowText)", pColor: #colorLiteral(red: 0.07300920051, green: 0.07300920051, blue: 0.07300920051, alpha: 1), fontName: "OpenSans-Regular", fontSize: 12)
        locationLabel.numberOfLines = 2
        locationLabel.preferredMaxLayoutWidth = 170
        
        locationLabel.adjustsFontSizeToFitWidth = false
        locationLabel.lineBreakMode = .byTruncatingTail
        addSubview(locationLabel)
        
        
        
        if isStartMarkerIW {
            locationLabel.anchor(top: topAnchor,left: timeInfoView.rightAnchor, bottom: bottomAnchor,right: rightAnchor, paddingTop: 6, paddingLeft: 5, paddingBottom: 6, paddingRight: 5)
            
        } else {
            
            locationLabel.anchor(top: topAnchor,left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6,paddingLeft: 5,paddingBottom: 6, paddingRight: 5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
