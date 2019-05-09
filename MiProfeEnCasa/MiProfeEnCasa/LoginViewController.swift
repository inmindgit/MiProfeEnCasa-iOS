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
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnContinueTap(_ sender: Any) {
        if(txtUserName.text == "" || txtPassword.text == "")
        {
            let alert = UIAlertController(title: "Mi Profe en Casa", message:"Las credenciales son incorrectas, por favor verifica", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
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
                            let alert = UIAlertController(title: "Mi Profe en Casa", message:"Las credenciales son incorrectas, por favor verifica", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
                else
                {}
            }
        }
    }
    
    @IBAction func btnNewPasswordTap(_ sender: Any) {
    }
    
}
