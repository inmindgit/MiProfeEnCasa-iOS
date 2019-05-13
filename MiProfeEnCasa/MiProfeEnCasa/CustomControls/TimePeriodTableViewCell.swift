//
//  TimePeriodTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/8/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

protocol TimePeriodTableViewCellDelegate {
    func setClassHour(index: Int)
}

class TimePeriodTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSelectTime: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    var delegate: TimePeriodTableViewCellDelegate?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSelectTime.backgroundColor = UIColor.white
        // Shadow and Radius
        btnSelectTime.layer.shadowColor = UIColor.lightGray.cgColor
        btnSelectTime.layer.shadowOffset = CGSize(width: 1, height: 1)
        btnSelectTime.layer.shadowRadius = 2
        btnSelectTime.layer.shadowOpacity = 1.0
    }

    @IBAction func btnSelectTimeTap(_ sender: Any) {
        self.delegate!.setClassHour(index: self.index!)
    }
}
