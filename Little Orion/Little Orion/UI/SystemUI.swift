//
//  SystemUI.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit
import ReSwift

class StarCell: UITableViewCell {
    static let id = "starCell"
    
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var starTitleLabel: UILabel!
    @IBOutlet var kindTitleLabel: UILabel!
    
    public var planet: Planet? {
        didSet {
            starTitleLabel.text = "\(planet!.name) (\(planet!.kind.name()))"
            let radius = String(format: "%.0f", planet!.radius)
            kindTitleLabel.text = "Score: \(planet!.resourceScore) | Radius: \(radius) Km"
            starImageView.image = planet!.kind.image()
            starImageView.transform = CGAffineTransform(scaleX: planet!.scale, y: planet!.scale)
        }
    }
}

protocol SystemUiDelegate {
    func systemUISelectedPlanet(planet: Planet)
}

class SystemUI: BaseUI, UITableViewDelegate, UITableViewDataSource, StoreSubscriber {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var starName: UILabel!
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var delegate: SystemUiDelegate?
    
    public var system: System? {
        didSet {
            if let system = system {
                titleLabel.text = system.description
                starName.text = "Star: \(system.star.kind.name())"
                starImageView.image = system.star.kind.image()
                tableView.reloadData()
            }
        }
    }
    
    public static func loadFromNib() -> SystemUI {
        let nib = UINib(nibName: "SystemUI", bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as! SystemUI
    }
    
    public func show() {
        system = store.state.uiState.selectedSystem
        store.subscribe(self) {
            $0.select{ $0.uiState }.skipRepeats()
        }
        isHidden = false
        alpha = 0
        layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
        UIView.animate(withDuration: 0.50,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 15,
                       options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        }, completion: nil)
    }
    
    public func hide() {
        store.unsubscribe(self)
        UIView.animate(withDuration: 0.30, animations: {
            self.alpha = 0
            self.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
        }, completion: {(success) in
            self.isHidden = true
        })
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    
        frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        center = superview!.center
        
        tableView.register(UINib(nibName: "StarCell", bundle: Bundle.main),
                                forCellReuseIdentifier: StarCell.id)
        tableView.rowHeight = 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let system = system {
            return system.planetsCount()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StarCell.id, for: indexPath) as! StarCell
        cell.planet = system!.planet(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let delegate = delegate {
            delegate.systemUISelectedPlanet(planet: system!.planet(at: indexPath.row))
        }
    }

    func newState(state: UIState) {
        if system != state.selectedSystem {
            system = state.selectedSystem
        }
    }
}
