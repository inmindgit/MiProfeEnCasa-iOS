//
//  CourseBasicDataTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class CourseBasicDataTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBasicData: UIImageView!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPreparationType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
