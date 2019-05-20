//
//  CourseAddressTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class CourseAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAddressTooltip: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
