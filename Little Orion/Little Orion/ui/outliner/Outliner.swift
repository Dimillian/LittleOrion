//
//  Outliner.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 26/03/2018.
//  Copyright © 2018 Thomas Ricouard. All rights reserved.
//

import UIKit
import ReSwift

protocol OutlinerDelegate: class {
    func outlinerDidChangeExpanded(outliner: Outliner, expanded: Bool)
}

class Outliner: BaseUI {

    @IBOutlet var expandButton: UIButton!
    @IBOutlet var tableView: UITableView!

    weak var delegate: OutlinerDelegate?

    let sections = ["Researching", "Systems", "Planets"]

    var expanded = false {
        didSet {
            delegate?.outlinerDidChangeExpanded(outliner: self, expanded: expanded)
        }
    }

    public static func loadFromNib() -> Outliner {
        let nib = UINib(nibName: "Outliner", bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! Outliner
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        tableView.register(UINib(nibName: OutlinerSystemTableViewCell.id, bundle: Bundle.main),
                           forCellReuseIdentifier: OutlinerSystemTableViewCell.id)

        store.subscribe(self) {
            $0.select{ $0.playerState }.skipRepeats()
        }
    }

    @IBAction func onExpandButton(_ sender: Any) {
        expanded = !expanded
    }
}

extension Outliner: StoreSubscriber {
    func newState(state: PlayerState) {
        tableView.reloadData()
    }
}

extension Outliner: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return store.state.playerState.player.discoveringEntities.count
        }
        else if section == 1 {
            return store.state.playerState.player.discoveredEntities.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OutlinerSystemTableViewCell.id) as? OutlinerSystemTableViewCell {

        }
        return UITableViewCell(frame: CGRect.zero)
    }

}
