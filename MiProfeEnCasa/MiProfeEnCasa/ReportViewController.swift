//
//  ReportViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/10/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit
import GBFloatingTextField
class ReportViewController: UIViewController {

    @IBOutlet weak var txtClassNumber: GBTextField!
    @IBOutlet weak var txtExercicesSubject: GBTextField!
    @IBOutlet weak var switchHomework: UISwitch!
    @IBOutlet weak var txtClarification: GBTextField!
    @IBOutlet weak var txtHomeworksForNextClass: GBTextField!
    @IBOutlet weak var txtObservations: GBTextField!
    @IBOutlet weak var btnOk: UIButton!
    
    var classsId: String!
    var courseId: String!
    var studentId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Informe"
    }
    
    @IBAction func btnOkTap(_ sender: Any)
    {
        if(validateData())
        {
            var parameter = "claseId=" + classsId
            parameter = parameter + "&numeroClase=" + self.txtClassNumber.text!
            parameter = parameter + "&temasEjercicios=" + Helpers.getStringParameter(parameter:self.txtExercicesSubject.text!)
            parameter = parameter + "&hizoDeberes=" + self.switchHomework!.isOn.description
            parameter = parameter + "&aclaraciones=" + Helpers.getStringParameter(parameter:self.txtClarification!.text!)
            parameter = parameter + "&observaciones=" + Helpers.getStringParameter(parameter:self.txtObservations.text!)
            parameter = parameter + "&alumnoId=" + self.studentId
            parameter = parameter + "&cursoAsociadoId=" + self.courseId
            
            ApiManager.sharedInstance.queryParameters = parameter
            ApiManager.sharedInstance.execute(type: ReportModel.self, operation: "post") { (response:AnyObject?) in
                if((response) != nil)
                {
                    if response is NSError
                    {}
                    else if response is ReportModel {
                        if((response as! ReportModel).code == 1)
                        {
                            let alert = UIAlertController(title: "Mi Profe en Casa", message:"Reporte enviado con éxito", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.changeRootViewControllerToSWRevealViewController()
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Mi Profe en Casa", message:(response as! ReportModel).error_message, preferredStyle: .alert)
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
    
    func validateData() -> Bool
    {
        var errorMessage = ""
        if(txtClassNumber.text == "")
        {
            txtClassNumber.becomeFirstResponder()
            errorMessage = "Debe ingresar un número de clase"
        }
        else if(txtExercicesSubject.text == "")
        {
            txtExercicesSubject.becomeFirstResponder()
            errorMessage = "Debe ingresar los ejercicios realizados"
        }

        else if(txtObservations.text == "")
        {
            txtObservations.becomeFirstResponder()
            errorMessage = "Debe ingresar las observaciones"
        }
        
        if(errorMessage == "")
        {
            return true
        }
        else
        {
            let alert = UIAlertController(title: "Mi Profe en Casa", message:errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return false
        }
    }
    
}
