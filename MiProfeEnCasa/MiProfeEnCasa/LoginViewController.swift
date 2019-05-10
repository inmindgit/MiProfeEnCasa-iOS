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
            errorMessage = "Por favor ingrese un E-Mail"
        }
        else if(txtPassword.text == "")
        {
            txtPassword.becomeFirstResponder()
            errorMessage = "Por favor ingrese una Contraseña"
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
                            let alert = UIAlertController(title: "Mi Profe en Casa", message:"Login Incorrecto, por favor revise los datos ingresados.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
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
            let alert = UIAlertController(title: "Mi Profe en Casa", message:errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func btnNewPasswordTap(_ sender: Any) {
    }
    
}
