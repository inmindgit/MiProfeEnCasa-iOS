//
//  SubjectsViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 11/14/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class SubjectsViewController: UIViewController {

    @IBOutlet weak var txtSubjects: UITextView!
    var subjectsText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSubjects.text = subjectsText
        self.title = NSLocalizedString("SUBJECTS", comment: "")
        // Do any additional setup after loading the view.
    }
}
