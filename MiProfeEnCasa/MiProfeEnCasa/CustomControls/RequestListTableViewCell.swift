//
//  RequestListTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class RequestListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTestDate: UILabel!
    @IBOutlet weak var lblStartingDate: UILabel!
    @IBOutlet weak var lblAmountOfClasesPerWeek: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
