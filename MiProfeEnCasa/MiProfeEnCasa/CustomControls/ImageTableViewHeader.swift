//
//  ImageTableViewHeader.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class ImageTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var imgHeader: UIImageView!
    static let reuseIdentifier: String = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
