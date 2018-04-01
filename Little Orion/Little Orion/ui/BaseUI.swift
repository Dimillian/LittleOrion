//
//  BaseUI.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit

extension UIView {
    public static func loadFromNib<T>() -> T {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! T
    }
}

class BaseUI: UIView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
