//
//  DestinationActionView.swift
//  UberClone
//
//  Created by Apple on 14.07.2021.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import GoogleUtilities


protocol DestinationActionViewDelegate: class {
    func handleConfirmRidePressed(_ view: DestinationActionView)
}

class DestinationActionView: UIView {
    
    // MARK: - Properties
    
    var destination: GMSPlace? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: DestinationActionViewDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "Heeps Coffee",pColor: UIColor.black ,fontName: "Avenir", fontSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "123 M. St, NW Washington DC",pColor: UIColor.lightGray ,fontName: "Avenir-Light", fontSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.defineLabelDetails(pText: "X", pColor: .white, fontName: "Avenir", fontSize: 30)
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "UBER X", pColor: UIColor.black, fontName: "Avenir", fontSize: 18)
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM UBERX", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleConfirmRidePressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleConfirmRidePressed() {
        delegate?.handleConfirmRidePressed(self)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        addShadow(shadowColor: .black, offSet: CGSize(width: 0.5, height: 0.5), opacity: 0.65, shadowRadius: 1)
        
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 16)
        infoView.setDimensions(height: 60, width: 60)
        infoView.layer.backgroundColor = UIColor.black.cgColor
        infoView.layer.cornerRadius = 30
        
        addSubview(infoLabel)
        infoLabel.centerX(inView: self)
        infoLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        addSubview(seperatorView)
        seperatorView.anchor(top: infoLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 12, height: 0.65)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 12, paddingRight: 16, height: 50)
    }
    
    func configure() {
        guard let destinationPlace = self.destination else { return }
        let viewModel = RideActionViewModel(place: destinationPlace)
        titleLabel.text = viewModel.name
        addressLabel.text = viewModel.adress
    }
    
}
