//
//  SelectionMenu.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 01/04/2018.
//  Copyright © 2018 Thomas Ricouard. All rights reserved.
//

import UIKit
import UI

class SelectionMenu: BaseUI {
    enum MenuType: Int {
        case unknown

        func datasource() -> [String] {
            switch self {
            case .unknown:
                return ["Discover", "Cancel"]
            }
        }
    }

    @IBOutlet var tableView: UITableView!

    var menuType = MenuType.unknown

    override func awakeFromNib() {
        super.awakeFromNib()

        let nib = UINib(nibName: SelectionMenuTableViewCell.id, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: SelectionMenuTableViewCell.id)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        center = superview!.center
    }
}

extension SelectionMenu: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuType.datasource().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionMenuTableViewCell.id,
                                                 for: indexPath) as! SelectionMenuTableViewCell
        cell.menuLabel.text = menuType.datasource()[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0, let entity = store.state.uiState.selectedEntity {
            store.dispatch(PlayerActions.startDiscoveryUniverseEntity(entity: entity.id))
        }
        store.dispatch(UIActions.DismissModal())
    }
}
