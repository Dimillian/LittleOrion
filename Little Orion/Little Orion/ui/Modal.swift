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
    fileprivate static var selectionUIShown = false
    fileprivate static var _systemUI: SystemUI?
    fileprivate static var _selectionUI: SelectionMenu?

    static var systemUI: SystemUI! {
        if _systemUI == nil {
            _systemUI = SystemUI.loadFromNib()
            _systemUI!.isHidden = true
        }
        return _systemUI!
    }

    static var selectionUI: SelectionMenu! {
        if _selectionUI == nil {
            _selectionUI = SelectionMenu.loadFromNib()
            _selectionUI!.isHidden = true
        }
        return _selectionUI!
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

    static func presentSelectionUI(from: SKScene) {
        if(!selectionUIShown) {
            selectionUIShown = true
            from.view?.addSubview(selectionUI)
            selectionUI.isHidden = false
        }
    }

    static func dismissSelectionUI() {
        selectionUI.isHidden = true
        selectionUIShown = false
    }
}
