//
//  LoginController.swift
//  UberClone
//
//  Created by Apple on 12.05.2021.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
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
    
    private lazy var passwordTextContainer: UIView = {
        let view = UIView().createCustomInputContainer(iconView: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), isSecureField: true, pTextField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().createCustomTextField(placeHolder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().createCustomTextField(placeHolder: "Password", isSecureField: true)
    }()
    
    private let loginButton = CustomAuthButton(buttonTitle: "Log In", action: #selector(handleLogin), target: self)
    
    private let dontHaveAnAccountButton = CustomAuthNavigatorButton(buttonTitle: "Don't have an account?", action: #selector(hanleNavigatingToRegistration), target: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print("DEBUG: An error occured during logging the user in. It appears to be \(err.localizedDescription)")
            }
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return }
            controller.configure()
            
            self.dismiss(animated: true, completion: nil)
            
        }}
    
    
    @objc func hanleNavigatingToRegistration() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)

    }
    
    
    // MARK: - Helpers
    
    
    func configureUI() {
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.rgb(r: 25, g: 25, b: 25, a: 1)
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: self.view)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextContainer, passwordTextContainer, loginButton])
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(lessThanOrEqualTo: emailTextContainer.widthAnchor, multiplier: 0.99).isActive = true
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        dontHaveAnAccountButton.centerX(inView: self.view)
        
    }
    
}
