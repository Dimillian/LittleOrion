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
    func outlinerDidSelectSystem(outliner: Outliner, system: UniverseId)
}

class Outliner: BaseUI {

    @IBOutlet var expandButton: UIButton!
    @IBOutlet var tableView: UITableView!

    var researchingSystems: [[UniverseId: Int]] = [] {
        didSet {
            if researchingSystems != oldValue {
                tableView.reloadData()
            }
        }
    }
    var discoveredSystems: [UniverseId] = [] {
        didSet {
            if discoveredSystems != oldValue {
                tableView.reloadData()
            }
        }
    }

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
        tableView.backgroundColor = .clear

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
        researchingSystems = state.player.discoveringEntities.compactMap({ [$0: $1] })
        discoveredSystems = state.player.discoveredEntities.filter({ store.state.universeState.universe!.entityAt(location: $0.location) is SystemEntity })
        tableView.reloadData()
    }
}

extension Outliner: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return researchingSystems.count
        }
        else if section == 1 {
            return discoveredSystems.count
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
            if indexPath.section == 0 {
                let system = researchingSystems[indexPath.row]
                cell.systemName.text = system.first!.key.name
                cell.systemDiscoveryProgress.isHidden = false
                let progress = system.first!.value
                cell.systemDiscoveryProgress.progress = Float(progress) / Float(UniverseEntity.dayToDisover)
            } else if indexPath.section == 1 {
                cell.systemName.text = discoveredSystems[indexPath.row].name
                cell.systemDiscoveryProgress.isHidden = true
            }
            return cell
        }
        return UITableViewCell(frame: CGRect.zero)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let system = researchingSystems[indexPath.row]
            delegate?.outlinerDidSelectSystem(outliner: self, system: system.first!.key)
        } else if indexPath.section == 1 {
            let system = discoveredSystems[indexPath.row]
            delegate?.outlinerDidSelectSystem(outliner: self, system: system)
        }
    }

}
