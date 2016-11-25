//
//  SystemUI.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit

class SystemUI: UIView {

    @IBOutlet var titleLabel: UILabel!
    
    public var system: System? {
        didSet {
            titleLabel.text = system?.description
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        self.center = self.superview!.center
    }
}
