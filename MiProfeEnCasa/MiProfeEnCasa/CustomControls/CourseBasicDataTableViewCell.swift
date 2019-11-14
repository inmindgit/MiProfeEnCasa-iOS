//
//  CourseBasicDataTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

protocol CourseBasicDataTableViewCellDelegate {
    func openSubjects()
}

class CourseBasicDataTableViewCell: UITableViewCell {

    @IBOutlet weak var imgBasicData: UIImageView!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPreparationType: UILabel!
    @IBOutlet weak var btnSubjectsToPrepare: UIButton!
    var delegate: CourseBasicDataTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnSubjectsToPrepare.setTitle(NSLocalizedString("SUBJECTS", comment: "").uppercased(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSubjectsToPrepareTap(_ sender: Any) {
        self.delegate?.openSubjects()
    }
}
