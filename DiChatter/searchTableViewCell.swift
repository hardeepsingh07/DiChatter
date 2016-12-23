//
//  searchTableViewCell.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/22/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class searchTableViewCell: UITableViewCell {

    @IBOutlet weak var sName: UILabel!
    @IBOutlet weak var sEmail: UILabel!
    @IBOutlet weak var sAdd: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
