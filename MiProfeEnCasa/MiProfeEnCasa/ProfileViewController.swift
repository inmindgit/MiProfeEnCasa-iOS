//
//  ProfileViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/2/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit
import SWRevealViewController
import GBFloatingTextField

class ProfileViewController: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var txtEmail: GBTextField!
    @IBOutlet weak var txtMobilePhone: GBTextField!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var user : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMenu()
        self.user = Helpers.getLoggedUser()
   
        self.title = (self.user?.nombre)! + " " + (self.user?.apellido)!
        txtMobilePhone.placeholder = NSLocalizedString("MOBILE", comment: "")
        txtEmail.placeholder = NSLocalizedString("E-MAIL", comment: "") 
        txtMobilePhone.text = self.user?.celular
        txtEmail.text = self.user?.email
    }
    

    func setupMenu()
    {
        btnMenu.target = self.revealViewController()
        self.revealViewController().rearViewRevealOverdraw = 0
        self.revealViewController().delegate = self
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.size.width - 100
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == .left) {
        } else {
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == .left) {
        } else {
        }
    }

    @IBAction func btnOkTap(_ sender: Any) {
        var errorMessage = ""
        
        if(txtMobilePhone.text == "")
        {
            txtMobilePhone.becomeFirstResponder()
            errorMessage = NSLocalizedString("NO_MOBLE_ERROR", comment: "")
        }
        else if(txtEmail.text == "" || !Helpers.isValidEmail(testStr: txtEmail.text!))
        {
            txtEmail.becomeFirstResponder()
            errorMessage = NSLocalizedString("NO_MAIL_ERROR", comment: "")
        }
        else
        {
            let apellido = user!.apellido!
            let direccionApto = user?.direccionApto! ?? ""
            let direccionCalle = user?.direccionCalle! ?? ""
            let direccionDepartamentoId = user?.direccionDepartamentoId! ?? 0
            let direccionEsquina = user?.direccionEsquina! ?? ""
            let direccionNumero = user?.direccionNumero! ?? ""
            let franquiciaId = user?.franquiciaId! ?? 0
            let nombre = user?.nombre! ?? ""
            let telefono = user?.telefono! ?? ""
            
            let userData =  ["apellido":apellido,
                             "celular":self.txtMobilePhone.text!,
                             "direccionApto":direccionApto,
                             "direccionCalle":direccionCalle,
                             "direccionDepartamentoId":direccionDepartamentoId,
                             "direccionEsquina":direccionEsquina,
                             "direccionNumero":direccionNumero,
                             "email":self.txtEmail.text!,
                             "franquiciaId":franquiciaId,
                             "imagenPrevia":"true",
                             "nombre":nombre,
                             "telefono":telefono] as [String : Any]
            
            if let theJSONData = try? JSONSerialization.data(withJSONObject: userData,options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                
                ApiManager.sharedInstance.queryParameters = "usuarioId=" + String(user!._id ?? 0) + "&datosUsuario=" + theJSONText!
                ApiManager.sharedInstance.execute(type: ProfileUpdateModel.self, operation: "post") { (response:AnyObject?) in
                    if((response) != nil)
                    {
                        if response is NSError
                        {}
                        else if response is ProfileUpdateModel {
                            if((response as! ProfileUpdateModel).code == 1)
                            {
                                Helpers.saveUserInDevice(user: (response as! ProfileUpdateModel).result!)
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.changeRootViewControllerToSWRevealViewController()
                            }
                            else
                            {
                                let alert = UIAlertController(title:  NSLocalizedString("APP_NAME", comment: ""), message:NSLocalizedString("PROFILE_UNSUCCESSFULLY", comment: ""), preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title:  NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                    else
                    {}
                }
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
