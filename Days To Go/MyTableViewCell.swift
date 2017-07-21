//
//  MyTableViewCell.swift
//  Days To Go
//
//  Created by Joe Riggs on 7/12/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

// This is the class for our custom TableView Cell style.

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var targetDate: UILabel!
    @IBOutlet weak var daysToGo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
