//
//  VideoListCell.swift
//  UMPY
//
//  Created by CBDev on 4/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
