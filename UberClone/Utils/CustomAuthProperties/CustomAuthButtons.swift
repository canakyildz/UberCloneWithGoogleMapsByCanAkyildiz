//
//  CustomAuthButtons.swift
//  UberClone
//
//  Created by Apple on 1.06.2021.
//

import UIKit

class CustomAuthButton: UIButton {
    
    init(buttonTitle: String, action: Selector, target: Any?) {
        super.init(frame: .zero)
        setTitleColor(.black, for: .normal)
        setTitle(buttonTitle, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        backgroundColor = .white
        titleLabel?.font = UIFont.customFont(name: "Avenir-Light", size: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class CustomAuthNavigatorButton: UIButton {
    
    init(buttonTitle: String, action: Selector, target: Any?) {
        super.init(frame: .zero)
        
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.lightGray, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        titleLabel?.font = UIFont.customFont(name: "Avenir-Light", size: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
