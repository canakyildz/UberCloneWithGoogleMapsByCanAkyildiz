//
//  LocationInputView.swift
//  UberClone
//
//  Created by Apple on 3.06.2021.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func handleLocationInputViewDismissal()
    func executeSearch(query: String)
}

class LocationInputView: UIView {
    
    // MARK: - Properties
    
    var user: User! {
        didSet {
            configure()
        }
    }
    
    weak var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.defineLabelDetails(pColor: .black, fontName: "Avenir",fontSize: 16)
        return label
    }()
    
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let indicatorLinkingLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.70
        return view
    }()
    
    private let destinationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şu Anki Konum"
        tf.textColor = .systemBlue
        tf.attributedPlaceholder = NSAttributedString(string: "Şu Anki Konum", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        tf.backgroundColor = #colorLiteral(red: 0.9450150698, green: 0.9450150698, blue: 0.9450150698, alpha: 1)
        tf.isEnabled = false
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.font = UIFont.customFont(name: "Avenir-Light", size: 14)
        return tf
    }()
    
    private lazy var destinatinoLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nereye?"
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        tf.font = UIFont.customFont(name: "Avenir-Light", size: 14)
        tf.delegate = self
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
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
    
    @objc func handleBackTapped() {
        delegate?.handleLocationInputViewDismissal()
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = .white
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 25)
        
        addShadow(shadowColor: .black, offSet: CGSize(width: 0.5, height: 0.5), opacity: 0.55, shadowRadius: 1)
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: backButton)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 40,paddingRight: 40, height: 30)
        
        
        addSubview(destinatinoLocationTextField)
        destinatinoLocationTextField.anchor(top: startingLocationTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 40,paddingRight: 40, height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerX(inView: backButton)
        startLocationIndicatorView.centerY(inView: startingLocationTextField)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 3
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerX(inView: backButton)
        destinationIndicatorView.centerY(inView: destinatinoLocationTextField)
        destinationIndicatorView.setDimensions(height: 6, width: 6)
        destinationIndicatorView.layer.cornerRadius = 0
        
        addSubview(indicatorLinkingLineView)
        indicatorLinkingLineView.anchor(top: startLocationIndicatorView.bottomAnchor, bottom: destinationIndicatorView.topAnchor, paddingTop: 2, paddingBottom: 2, width: 0.5)
        indicatorLinkingLineView.centerX(inView: startLocationIndicatorView)
    }
    
    func configure() {
        guard let user = self.user else { return }
        let viewModel = HomeTitleViewModel(user: user)
        titleLabel.text = viewModel.name
        
    }
    
}

// MARK: - UITextFieldDelegate

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else { return false }
        delegate?.executeSearch(query: query)
        return true
    }
}
