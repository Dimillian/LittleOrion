//
//  Modal.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ModalUI {

    fileprivate static var systemUIShown = false
    fileprivate static var _systemUI: SystemUI?
    static var systemUI: SystemUI! {
        get {
            if _systemUI == nil {
                _systemUI = SystemUI.loadFromNib()
                _systemUI!.isHidden = true
            }
            return _systemUI!
        }
    }

    static func presentSystemUI(from: SKScene, delegate: SystemUiDelegate) {
        if (!systemUIShown) {
            systemUIShown = true
            from.view?.addSubview(systemUI)
            systemUI.delegate = delegate
            systemUI.show()
        }
    }

    static func dismissSystemUI() {
        systemUI.hide()
        systemUIShown = false
    }
}
