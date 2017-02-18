//
//  BottomBar.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 22/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

class BottomBar: BaseUI, StoreSubscriber {
    
    @IBOutlet var planetNumber: UILabel!
    
    public static func loadFromNib() -> BottomBar {
        let nib = UINib(nibName: "BottomBar", bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! BottomBar
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        layer.cornerRadius = 0

        store.subscribe(self) {
            $0.select{ $0.playerState }.skipRepeats()
        }
    }

    func newState(state: PlayerState) {
        self.planetNumber.text = "Planets: \(state.player.visitedPlanets.count)"
    }
}
