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
        self.title = "Restablecer contraseña"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
            errorMessage = "Por favor ingrese un E-Mail"
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
                            let alert = UIAlertController(title: "Mi Profe en Casa", message:"Solicitud procesada con éxito", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.changeRootViewControllerToLoginViewController()
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Mi Profe en Casa", message:(response as! ResetPasswordModel).error_message, preferredStyle: .alert)
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

}
