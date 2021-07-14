//
//  RegistrationController.swift
//  UberClone
//
//  Created by Apple on 1.06.2021.
//

import UIKit
import Firebase
import GeoFire

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.85)
        return label
    }()    
    private lazy var emailTextContainer: UIView = {
        let view = UIView().createCustomInputContainer(iconView: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), pTextField: emailTextField)
        return view
    }()
    private lazy var nameTextContainer: UIView = {
        let view = UIView().createCustomInputContainer(iconView: #imageLiteral(resourceName: "ic_person_outline_white_2x"), pTextField: nameTextField)
        return view
    }()
    
    
    private lazy var passwordTextContainer: UIView = {
        let view = UIView().createCustomInputContainer(iconView: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), isSecureField: true, pTextField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().createCustomTextField(placeHolder: "Email")
    }()
    
    private let nameTextField: UITextField = {
        return UITextField().createCustomTextField(placeHolder: "Name")
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().createCustomTextField(placeHolder: "Password", isSecureField: true)
    }()
    private let registrationButton = CustomAuthButton(buttonTitle: "Register", action: #selector(handleRegistration), target: self)
    
    private let alreadyHaveAnAccountButton = CustomAuthNavigatorButton(buttonTitle: "Already have an account?", action: #selector(handleNavigatingBackToLC), target: self)
    
    private lazy var accountTypeSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.layer.cornerRadius = 0
        return sc
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    // MARK: - Selectors
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentedController.selectedSegmentIndex
        let credentials = AuthCredentials.init(email: email, accountTypeIndex: accountTypeIndex, password: password, fullname: name)
        
        
        AuthService.registerUser(withCredentials: credentials) { (err, ref) in
            if let err = err {
                print("DEBUG: During registration call, an error occured, description of it is \(err.localizedDescription)")
                
            }
            
            
            
            print("does it even dismiss?")
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return }
            controller.configure()
            
            self.dismiss(animated: true, completion: nil)
        }

        
    }
    
    
    @objc func handleNavigatingBackToLC() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = UIColor.rgb(r: 25, g: 25, b: 25, a: 1)
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: self.view)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextContainer,nameTextContainer, passwordTextContainer, accountTypeSegmentedController, registrationButton])
        registrationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registrationButton.widthAnchor.constraint(lessThanOrEqualTo: emailTextContainer.widthAnchor, multiplier: 0.99).isActive = true
        accountTypeSegmentedController.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillProportionally
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        alreadyHaveAnAccountButton.centerX(inView: self.view)
        
    }}
