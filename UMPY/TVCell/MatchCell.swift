//
//  MatchCell.swift
//  UMPY
//
//  Created by CBDev on 3/22/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var matchTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
