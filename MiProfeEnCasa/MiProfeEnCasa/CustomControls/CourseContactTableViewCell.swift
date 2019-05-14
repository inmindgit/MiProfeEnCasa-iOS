//
//  CourseContactTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class CourseContactTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
