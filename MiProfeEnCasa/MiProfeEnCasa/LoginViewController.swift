//
//  LoginViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnNewPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
        
    @IBAction func btnContinueTap(_ sender: Any) {
        var errorMessage = ""

        if(txtUserName.text == "" || !(Helpers.isValidEmail(testStr: txtUserName.text!)))
        {
            txtUserName.becomeFirstResponder()
            errorMessage = NSLocalizedString("NO_MAIL_ERROR", comment: "")
        }
        else if(txtPassword.text == "")
        {
            txtPassword.becomeFirstResponder()
            errorMessage = NSLocalizedString("NO_PASSWORD_ERROR", comment: "")
        }
        else
        {
            ApiManager.sharedInstance.queryParameters = "email=" + Helpers.getStringParameter(parameter: txtUserName!.text!) + "&password=" + Helpers.getStringParameter(parameter: txtPassword!.text!) + "&tipoLogin=4"
            ApiManager.sharedInstance.execute(type: LoginModel.self, operation: "post") { (response:AnyObject?) in
                if((response) != nil)
                {
                    if response is NSError
                    {}
                    else if response is LoginModel {
                        if((response as! LoginModel).code == 1)
                        {
                            Helpers.saveUserInDevice(user: (response as! LoginModel).result!)
                            
                            let defaults = UserDefaults.standard
                            defaults.set(true, forKey: Constants.UserDefaults.kIsUserLoggedIn)
                            defaults.synchronize()
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.changeRootViewControllerToSWRevealViewController()
                        }
                        else
                        {
                            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:NSLocalizedString("LOGIN_ERROR", comment: ""), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title:  NSLocalizedString("APP_NAME", comment: ""), style: .default, handler: nil))
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
            alert.addAction(UIAlertAction(title:  NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func btnNewPasswordTap(_ sender: Any) {
        let  recoverPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecoverPasswordViewController") as! RecoverPasswordViewController
        
        self.navigationController?.pushViewController(recoverPasswordViewController, animated: true)
    }
    
}
