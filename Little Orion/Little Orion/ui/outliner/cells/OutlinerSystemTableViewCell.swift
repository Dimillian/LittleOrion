//
//  OutlinerSystemTableViewCell.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 26/03/2018.
//  Copyright © 2018 Thomas Ricouard. All rights reserved.
//

import UIKit

class OutlinerSystemTableViewCell: UITableViewCell {

    static let id = "OutlinerSystemTableViewCell"

    @IBOutlet var systemName: UILabel!
    @IBOutlet var systemDiscoveryProgress: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
