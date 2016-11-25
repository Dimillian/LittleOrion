//
//  BaseUI.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit

class BaseUI: UIView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = false
    }
}
