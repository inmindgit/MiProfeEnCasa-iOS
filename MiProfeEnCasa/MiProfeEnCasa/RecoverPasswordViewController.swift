//
//  RecoverPasswordViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit
import GBFloatingTextField

class RecoverPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: GBTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = NSLocalizedString("RESET_PASSWORD", comment: "")
    }        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func btnRecoverTap(_ sender: Any) {
        var errorMessage = ""
        
        if(txtEmail.text == "" || !(Helpers.isValidEmail(testStr: txtEmail.text!)))
        {
            txtEmail.becomeFirstResponder()
            errorMessage = NSLocalizedString("NO_MAIL_ERROR", comment: "")
        }
        else
        {
            ApiManager.sharedInstance.queryParameters = "email=" + Helpers.getStringParameter(parameter: txtEmail!.text!) 
            ApiManager.sharedInstance.execute(type: ResetPasswordModel.self, operation: "post") { (response:AnyObject?) in
                if((response) != nil)
                {
                    if response is NSError
                    {}
                    else if response is ResetPasswordModel {
                        if((response as! ResetPasswordModel).code == 1)
                        {
                            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: "") , message:NSLocalizedString("REQUEST_SUCCESSFULLY", comment: "") , preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                            self.txtEmail.resignFirstResponder()
                            self.present(alert, animated: true)
                            
                            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            //appDelegate.changeRootViewControllerToLoginViewController()
                        }
                        else
                        {
                            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:(response as! ResetPasswordModel).error_message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
                else
                {}
            }
        }
        
        if(errorMessage != "")
        {
            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
