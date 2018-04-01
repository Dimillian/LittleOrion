//
//  SelectionMenuTableViewCell.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 01/04/2018.
//  Copyright © 2018 Thomas Ricouard. All rights reserved.
//

import UIKit

class SelectionMenuTableViewCell: UITableViewCell {

    static let id = "SelectionMenuTableViewCell"
    
    @IBOutlet var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
