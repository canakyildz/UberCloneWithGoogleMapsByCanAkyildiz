//
//  HomeTitleViewModel.swift
//  UberClone
//
//  Created by Apple on 4.06.2021.
//

import UIKit

struct HomeTitleViewModel {
    
    private var user: User
    let name: String
//    let location: String
//    let professionType: String
    
    
    init(user: User) {
        self.user = user
        
       
        name = user.fullname
    }
}
