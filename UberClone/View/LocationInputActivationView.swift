//
//  LocationInputActivationView.swift
//  UberClone
//
//  Created by Apple on 3.06.2021.
//

import UIKit

protocol LocationInputActivatorViewDelegate: class {
    func showLocationInputView()
}

class LocationInputActivatorView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LocationInputActivatorViewDelegate?
    
    
    let placeHolder: UILabel = {
        let label = UILabel()
        label.text = "Nereye?"
        label.font = UIFont.customFont(name: "OpenSans-SemiBold", size: 18)
        label.textColor = #colorLiteral(red: 0.1130433058, green: 0.1130433058, blue: 0.1130433058, alpha: 1)
        return label
    }()
    
    let pickSavedLocationButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("    Kaydedilen yer seçin", for: .normal)
        button.titleLabel?.defineLabelDetails(pText: "  Kaydedilen yer seçin", pColor: .black, fontName: "OpenSans-Regular", fontSize: 15)
        button.setImage(#imageLiteral(resourceName: "favt1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.anchor(left: button.leftAnchor,width: 22, height: 21)
        button.imageView?.centerY(inView: button)
        button.titleLabel?.anchor(left: button.imageView?.rightAnchor,right: button.rightAnchor, paddingLeft: 12)
        return button
    }()
    
    let seperatorView: UIView = {
        let vv = UIView()
        vv.backgroundColor = .lightGray
        return vv
    }()
    
    let determineDestinationButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("    Haritada varış noktası ayarla", for: .normal)
        button.titleLabel?.defineLabelDetails(pText: "  Haritada varış noktası ayarla", pColor: .black, fontName: "OpenSans-Regular", fontSize: 15)
        button.setImage(#imageLiteral(resourceName: "loct2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.anchor(left: button.leftAnchor,width: 22, height: 21)
        button.imageView?.centerY(inView: button)
        button.titleLabel?.anchor(left: button.imageView?.rightAnchor,right: button.rightAnchor, paddingLeft: 12)
        return button
    }()
    
    let footerView: UIView = {
        let vv = UIView()
        vv.backgroundColor = #colorLiteral(red: 0.9320941691, green: 0.9320941691, blue: 0.9320941691, alpha: 1)
        return vv
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
    
    @objc func showLocationInputView() {
        delegate?.showLocationInputView()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
                
        let placeHolderView = UIView()
        addSubview(placeHolderView)
        placeHolderView.backgroundColor = #colorLiteral(red: 0.9320941691, green: 0.9320941691, blue: 0.9320941691, alpha: 1)
        placeHolderView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 24,paddingLeft: 16, paddingRight: 16, height: 60)
        
    
        addSubview(placeHolder)
        placeHolder.centerY(inView: placeHolderView)
        placeHolder.anchor(left: placeHolderView.leftAnchor ,right: placeHolderView.rightAnchor, paddingLeft: 12)
        placeHolder.sendSubviewToBack(placeHolderView)
        
        addSubview(pickSavedLocationButton)
        pickSavedLocationButton.anchor(top: placeHolderView.bottomAnchor, left: placeHolderView.leftAnchor,paddingTop: 12,height: 50)
        
        addSubview(seperatorView)
        seperatorView.anchor(top: pickSavedLocationButton.bottomAnchor, left: placeHolderView.leftAnchor, right: placeHolderView.rightAnchor,paddingTop: 8,paddingLeft: 35,height: 0.5)
        
        addSubview(determineDestinationButton)
        determineDestinationButton.anchor(top: seperatorView.bottomAnchor, left: placeHolderView.leftAnchor,right: placeHolderView.rightAnchor,paddingTop: 10,height: 50)


        addSubview(footerView)
        footerView.anchor(top: determineDestinationButton.bottomAnchor,left: leftAnchor, right: rightAnchor,paddingTop: 12,height: 10)
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(showLocationInputView))
        addGestureRecognizer(tapGestureRec)
        
        
    }
    
}
