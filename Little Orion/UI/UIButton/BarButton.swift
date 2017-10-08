//
//  BarButton.swift
//  UI
//
//  Created by Thomas Ricouard on 08/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import UIKit

@IBDesignable
class BarButton: UIButton {

    override func awakeFromNib() {
        setup()
    }

    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    func setup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
    }

}
