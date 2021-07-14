//
//  MainHeaderView.swift
//  UberClone
//
//  Created by Apple on 17.06.2021.
//

import UIKit

protocol MainHeaderViewDelegate: class {
    func handleStartTripButtonPressed()
}

class MainHeaderView: UIView {
    
    
    // MARK: - Properties
    
    weak var delegate: MainHeaderViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear

        label.defineLabelDetails(pText: "Bir araya gelin", pColor: .white, fontName: "OpenSans-SemiBold", fontSize: 22)
        return label
    }()
    
    private let explanatoryLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pText: "Doğrudan sevdiklerinize giderek onları \nziyaret edin", pColor: .white, fontName: "OpenSans-Regular", fontSize: 14)
        label.numberOfLines = 2
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var startTripButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yolculuk yapın", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.defineLabelDetails(fontName: "OpenSans-SemiBold", fontSize: 12)
        button.titleLabel?.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 3, paddingLeft: 8, paddingBottom: 3, paddingRight: 8)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleStartTripTouched), for: .touchUpInside)
        return button
    }()
    
    private let downView: UIView = {
        let vv = UIView()
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "testnoww"))
        vv.sendSubviewToBack(iv)
        vv.addSubview(iv)
        iv.fillSuperview()
        
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
    
    @objc func handleStartTripTouched() {
        delegate?.handleStartTripButtonPressed()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0.158192426, green: 0.4275941253, blue: 0.9435395002, alpha: 1)
        let stack = UIStackView(arrangedSubviews: [titleLabel, explanatoryLabel])
        stack.spacing = 2
        stack.axis = .vertical
        stack.backgroundColor = .clear
        addSubview(stack)
        stack.anchor(left: leftAnchor,right: rightAnchor, paddingLeft: 24)
        stack.centerY(inView: self)
        
        addSubview(startTripButton)
        startTripButton.anchor(top: stack.bottomAnchor, left: stack.leftAnchor,paddingTop: 8, height: 30)

        
        addSubview(downView)
        downView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 104)
        bringSubviewToFront(startTripButton)


        
    }
    
    
    
}
