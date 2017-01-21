//
//  TopBar.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import UIKit
import ReSwift

class TopBar: BaseUI {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    
    public static func loadFromNib() -> TopBar {
        let nib = UINib(nibName: "TopBar", bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! TopBar
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        layer.cornerRadius = 0

        store.subscribe(self) {state in
            state.playerState
        }
    }
    @IBAction func onPlayButton(_ sender: Any) {
        if store.state.playerState.isPlaying {
            store.dispatch(PauseDateTimer())
        }
        else {
            store.dispatch(StartDateTimer())
        }
    }
}

extension TopBar: StoreSubscriber {
    func newState(state: PlayerState) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: state.currentDate)
        playButton.setTitle(state.isPlaying ? "||" : ">", for: .normal)
    }
}
