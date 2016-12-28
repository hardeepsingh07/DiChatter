//
//  friendTableViewCell.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/20/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class friendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var fEmail: UILabel!
    @IBOutlet weak var fDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
