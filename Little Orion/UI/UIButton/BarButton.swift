//
//  BarButton.swift
//  UI
//
//  Created by Thomas Ricouard on 08/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import UIKit

@IBDesignable
open class BarButton: UIButton {

    override open func awakeFromNib() {
        setup()
    }

    override open func prepareForInterfaceBuilder() {
        setup()
    }
    
    func setup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
    }

}
