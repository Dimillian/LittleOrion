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
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        clipsToBounds = false
    }
}
