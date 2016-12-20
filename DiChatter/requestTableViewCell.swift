//
//  requestTableViewCell.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/19/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class requestTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rName: UILabel!
    @IBOutlet weak var rEmail: UILabel!
    @IBOutlet weak var rAccept: UIButton!
    @IBOutlet weak var rDecline: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
