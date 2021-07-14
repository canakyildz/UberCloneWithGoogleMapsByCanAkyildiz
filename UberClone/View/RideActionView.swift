//
//  RideActionView.swift
//  UberClone
//
//  Created by Apple on 9.06.2021.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import GoogleUtilities


protocol RideActionViewDelegate: class {
    func handleConfirmRidePressed(_ view: RideActionView)
}

class RideActionView: UIView {
    
    // MARK: - Properties
    
    var destination: GMSPlace? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: RideActionViewDelegate?
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "123 M. St, NW Washington DC",pColor: UIColor.black ,fontName: "HelveticaNeue", fontSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
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
        button.setTitle("Taksi Çağırın", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleConfirmRidePressed), for: .touchUpInside)
        return button
    }()
    
    private var creditLabel: UILabel = {
        let label = UILabel()
        label.text = "₺0,00 kredi"
        label.defineLabelDetails(pText: "₺0,00 kredi", pColor: .black, fontName: "HelveticaNeue", fontSize: 15)
        return label
    }()
    
    private let creditLabelUberIcon: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Katman 2").withRenderingMode(.alwaysOriginal))
        iv.setDimensions(height: 24.5, width: 34)
        return iv
    }()
    
    private let vehicleInfoView: UIView = {
        let vv = UIView()
        
        let vehicleImage = UIImageView(image: #imageLiteral(resourceName: "Siyah-Beyaz 1"))
        vv.addSubview(vehicleImage)
        vehicleImage.setDimensions(height: 69/2, width: 111/2)
        
        let vehicleNickLabel = UILabel()
        vehicleNickLabel.defineLabelDetails(pText: "Siyah Taksi", pColor: .black, fontName: "HelveticaNeue", fontSize: 16)
        
        let vehicleArrivalTimeLabel = UILabel()
        vehicleArrivalTimeLabel.defineLabelDetails(pText: "13:25", pColor: .black, fontName: "HelveticaNeue-Light", fontSize: 14)
        
        let vehicleNickAndArrivalStack = UIStackView(arrangedSubviews: [vehicleNickLabel, vehicleArrivalTimeLabel])
        vehicleNickAndArrivalStack.axis = .vertical
        vehicleNickAndArrivalStack.distribution = .fillEqually
        vv.addSubview(vehicleNickAndArrivalStack)
        
        vehicleImage.centerY(inView: vv, leftAnchor: vv.leftAnchor, paddingLeft: 16, constant: 0)
        vehicleNickAndArrivalStack.anchor(top: vehicleImage.topAnchor,left: vehicleImage.rightAnchor,bottom: vehicleImage.bottomAnchor, paddingLeft: 10)
        
        
        return vv
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "₺14-15", pColor: .black, fontName: "HelveticaNeue", fontSize: 16)
        return label
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
        
        
        
        addSubview(addressLabel)
        addressLabel.anchor(top: topAnchor,left: leftAnchor, right: rightAnchor, paddingLeft: 8,paddingRight: 8 ,height: 44)
        
        let firstSeperatorView = UIView()
        firstSeperatorView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        addSubview(firstSeperatorView)
        firstSeperatorView.anchor(top: addressLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 4, height: 0.65)

        
        addSubview(vehicleInfoView)
        vehicleInfoView.anchor(top: firstSeperatorView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 2, height: 80)
        
        addSubview(costLabel)
        costLabel.anchor(top: vehicleInfoView.topAnchor, right: rightAnchor,paddingTop: 20,paddingRight: 16, height: 20)
        
        let secondSeperatorView = UIView()
        secondSeperatorView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        addSubview(secondSeperatorView)
        secondSeperatorView.anchor(top: vehicleInfoView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 2, height: 0.55)
        
        let creditStack = UIStackView(arrangedSubviews: [creditLabelUberIcon, creditLabel])
        creditStack.axis = .horizontal
        creditStack.spacing = 12
        creditStack.distribution = .fillProportionally
        addSubview(creditStack)
        creditStack.anchor(top: secondSeperatorView.bottomAnchor, left:leftAnchor,right: rightAnchor,paddingTop: 21, paddingLeft: 16)
        
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 12, paddingRight: 16, height: 50)
    }
    
    func configure() {
        guard let place = self.destination else { return }
        let viewModel = RideActionViewModel(place: place)
        addressLabel.text = "\(viewModel.name), \(viewModel.adress)"
    }

}
