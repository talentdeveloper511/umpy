//
//  DeviceCell.swift
//  UMPY
//
//  Created by CBDev on 3/14/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {
    @IBOutlet weak var deviceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
