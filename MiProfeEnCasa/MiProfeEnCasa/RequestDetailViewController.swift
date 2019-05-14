//
//  RequestListViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class RequestDetailViewController: UIViewController, ScheduleTableViewCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    let imageView = UIImageView()
    var request: RequestModel?
    var pickerHours = [["1","2","3","4","5","6","7","8","9","10"],["0", "5"]];
    var hoursOfClases: [String]?
    var hourPicker = UIPickerView()
    var isClassHourPickerSelection : Bool = false
    var selectedRow : Int = 0
    var classesOfDay: [ScheduleModel]?
    
    @IBOutlet weak var txtPickerDispaly: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("REQUEST_DETAIL", comment: "")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.setupHourPicker()
        self.setupTableView()
        self.setupHeaderImageView()
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 160 - (scrollView.contentOffset.y + 160)
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
    }
    
    func setupHeaderImageView()
    {
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160)
        imageView.image = UIImage.init(named: "classroom")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    func setupTableView()
    {
        tableView.register(UINib(nibName: "CourseBasicDataTableViewCell", bundle: nil), forCellReuseIdentifier: "cellBasic")
        tableView.register(UINib(nibName: "CourseAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "cellAddress")
        tableView.register(UINib(nibName: "CourseContactDataTableViewCell", bundle: nil), forCellReuseIdentifier: "cellContact")
        tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSchedule")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
    }
    
    func setupHourPicker()
    {
        self.hourPicker.dataSource = self
        self.hourPicker.delegate = self
        
        let btnDone = UIBarButtonItem(title: NSLocalizedString("ASSIGN", comment: ""), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("CANCEL", comment: ""), style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        
        let barAccessory = UIToolbar()
        barAccessory.barStyle = .default
        barAccessory.isTranslucent = false
        barAccessory.items = [cancelButton, spaceButton, btnDone]
        barAccessory.sizeToFit()
        self.txtPickerDispaly.inputAccessoryView = barAccessory
        self.txtPickerDispaly.inputView = self.hourPicker
    }
    
    @objc func doneButtonTapped()
    {
        self.txtPickerDispaly.resignFirstResponder()
        if(self.isClassHourPickerSelection)
        {
            let hoursAndMinutesOfClass = [self.hoursOfClases!,["00", "30"]];
            let hour =  hoursAndMinutesOfClass[0][self.hourPicker.selectedRow(inComponent: 0)]
            let minutes = hoursAndMinutesOfClass[1][hourPicker.selectedRow(inComponent: 1)]
            
            let startTime = self.classesOfDay![self.selectedRow].horarioComienzo
            let endTime = self.classesOfDay![self.selectedRow].horarioFin
            let index = startTime!.index(of: ":")!.encodedOffset
            let startHourInteger =  Int(startTime![0..<index])
            let startMinutesInteger =  Int(startTime![index + 1..<(startTime?.count)!])
            let indexEndTime = endTime!.index(of: ":")!.encodedOffset
            
            let endHourInteger =  Int(endTime![0..<indexEndTime])
            let endMinutesInteger =  Int(endTime![indexEndTime + 1..<(endTime?.count)!])
            
            if(Helpers.validateTimeInRange(startHour: startHourInteger!, startMinutes: startMinutesInteger!, endHour: endHourInteger!, endMinutes: endMinutesInteger!, selectedHour:Int(hour)!, selectedMinutes:Int(minutes)!))
            {
                self.setStartingClassTime(dateAndHour: hour + ":" + minutes)
            }
            else
            {
                let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:NSLocalizedString("RANGE_SELECTION_ERROR", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else
        {
            self.setAmountOfHours()
        }
    }
    
    func setAmountOfHours()
    {
        let claseId = self.request?.claseId
        let hours =  self.pickerHours[0][self.hourPicker.selectedRow(inComponent: 0)]
        let minutes = self.pickerHours[1][hourPicker.selectedRow(inComponent: 1)]

        if(Helpers.validateMinimunTimeRequest(selectedHour: Int(hours)!, selectedMinutes: Int(minutes)!))
        {
            ApiManager.sharedInstance.queryParameters = "claseId=" + String(claseId ?? 0) + "&cantidadHoras=" + hours + "." + minutes
            ApiManager.sharedInstance.execute(type: ClassSetHoursModel.self, operation: "post") { (response:AnyObject?) in
                if((response) != nil)
                {
                    if response is NSError
                    {}
                    else if response is ClassSetHoursModel {
                        if((response as! ClassSetHoursModel).code == 1)
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.changeRootViewControllerToSWRevealViewController()
                        }
                        else
                        {
                            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:(response as! ClassSetHoursModel).error_message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
                else
                {}
            }
        }
        
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:NSLocalizedString("TIME_SELECTION_ERROR", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func setStartingClassTime(dateAndHour : String)
    {
        let solicitudMaestroId = self.request?._id
        let fecha = self.request?.SAfechaInicio
        let horaComienzo = dateAndHour
        
        let primeraClase =  ["fecha":fecha, "horaComienzo":horaComienzo]
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: primeraClase,options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            
            ApiManager.sharedInstance.queryParameters = "solicitudMaestroId=" + String(solicitudMaestroId ?? 0) + "&primeraClase=" + theJSONText!
            ApiManager.sharedInstance.execute(type: RequestAcceptModel.self, operation: "post") { (response:AnyObject?) in
                if((response) != nil)
                {
                    if response is NSError
                    {}
                    else if response is RequestAcceptModel {
                        if((response as! RequestAcceptModel).code == 1)
                        {
                            
                            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message: NSLocalizedString("REQUEST_TIME_SELECTED", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            
                            let acceptAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .cancel) { action -> Void in
                                let  requestListViewController = self.storyboard?.instantiateViewController(withIdentifier: "RequestListViewController") as! RequestListViewController
                                self.navigationController?.pushViewController(requestListViewController, animated: true)
                            }
                            alert.addAction(acceptAction)
                            self.present(alert, animated: true, completion: nil)

                        }
                        else
                        {
                            let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:(response as! RequestAcceptModel).error_message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func cancelButtonTapped()
    {
        self.txtPickerDispaly.resignFirstResponder()
    }
    
    func loadTimeOrAddReport() {
        self.isClassHourPickerSelection = false
        
        if((self.request?.estadoSolicitudMaestroId)! == Constants.RequestStatus.kRequestEnded)
        {
            let  reportViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
            reportViewController.classsId = String(request?.claseId ?? 0)
            reportViewController.courseId = String(request?.cursoAsociadoId ?? 0)
            reportViewController.studentId = String(request?.solicitudAlumnoId ?? 0)
            self.navigationController?.pushViewController(reportViewController, animated: true)
        }
        else
        {
            if(Helpers.validateClassTime(startingDate: (self.request?.SAfechaInicio)!))
            {
                self.txtPickerDispaly.becomeFirstResponder()
            }
            else
            {
                let alert = UIAlertController(title: NSLocalizedString("APP_NAME", comment: ""), message:NSLocalizedString("LOAD_TIME_UNAVAILABLE", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ACCEPT", comment: ""), style: .default, handler: nil))
                self.present(alert, animated: true)
            }
                
        }
    }
    
    func selectClassHours(classesOfDay: [ScheduleModel], index: Int)
    {
        self.isClassHourPickerSelection = true
        self.calculateHoursInterval(classesOfDay: classesOfDay, rowIndex: index)
        self.txtPickerDispaly.becomeFirstResponder()
    }
    
    func calculateHoursInterval(classesOfDay: [ScheduleModel], rowIndex: Int)
    {
        self.selectedRow = rowIndex
        self.classesOfDay = classesOfDay
        let startTime = classesOfDay[rowIndex].horarioComienzo
        let endTime = classesOfDay[rowIndex].horarioFin
        let index = startTime!.index(of: ":")!.encodedOffset
        let startHourInteger =  Int(startTime![0..<index])
        let indexEndTime = endTime!.index(of: ":")!.encodedOffset
        let endHourInteger =  Int(endTime![0..<indexEndTime])
        
        var hoursToDisplay = 0
        if let  sh = startHourInteger {
            if let eh = endHourInteger {
                hoursToDisplay = eh - sh
                self.hoursOfClases = [String]()
            }
        }
        
        for i in 0...hoursToDisplay - 1 {
            self.hoursOfClases?.append(String(startHourInteger! + i))
        }
    }
}

extension RequestDetailViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellBasic", for: indexPath) as! CourseBasicDataTableViewCell
            cell.lblCourse.text = self.request?.Cnombre
            cell.lblDescription.text = self.request?.Cdescripcion
            cell.lblPreparationType.text = self.request?.SAprueba
            return cell
        }
        else if(indexPath.row == 1)
        {
            if(self.request?.estadoSolicitudMaestroId == Constants.RequestStatus.kRequestNotReaded || self.request?.estadoSolicitudMaestroId == Constants.RequestStatus.kRequestReaded || self.request?.estadoSolicitudMaestroId == Constants.RequestStatus.kRequestReaded )
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellAddress", for: indexPath) as! CourseAddressTableViewCell
                if(self.request?.UdireccionCalle != nil && self.request?.UdireccionEsquina != nil)
                {
                    cell.lblAddress.text = (self.request?.UdireccionCalle)! + " esquina " + (self.request?.UdireccionEsquina)!
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellContact", for: indexPath) as! CourseContactDataTableViewCell
                
                if(self.request?.UdireccionCalle != nil && self.request?.UdireccionEsquina != nil)
                {
                    cell.lblAddress.text = (self.request?.UdireccionCalle)! + " esquina " + (self.request?.UdireccionEsquina)!
                }
                
                cell.lblStudentName.text = (self.request?.Unombre)! + " " + (self.request?.Uapellido)!
                cell.lblPhone.text = self.request?.Ucelular!
                
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSchedule", for: indexPath) as! ScheduleTableViewCell
            cell.hideControls(requestStatus: (self.request?.estadoSolicitudMaestroId)!)
            cell.request = self.request
            cell.delegate = self
            
            if(self.request?.estadoSolicitudMaestroId == Constants.RequestStatus.kRequestNotReaded || self.request?.estadoSolicitudMaestroId == Constants.RequestStatus.kRequestReaded)
            {
                cell.sortAvailableTimesPerDay(request: self.request)
            }
        
            if let date = self.request?.SAfechaInicio
            {
                cell.lblStartingDate.text = Helpers.formatDateToShow(date:date)
            }
            
            if let date = self.request?.SAfechaInicio
            {
                if(self.request?.estadoSolicitudMaestroId == Constants.RequestStatus.kRequestPreAccepted)
                {
                    cell.lblStartingDateTooltip.text = NSLocalizedString("START_CLASS_PROPOSAL_DATE", comment: "")
                    cell.lblStartingDate.text = Helpers.formatDateToShow(date:date) + " " + (self.request?.claseHorario)!
                }
                else
                {
                    cell.lblStartingDateTooltip.text = NSLocalizedString("START_CLASS_DATE", comment: "")
                    cell.lblStartingDate.text = Helpers.formatDateToShow(date:date)
                }
            }
            
            if let date = self.request?.SAfechaPrueba
            {
                cell.lblTestDate.text = Helpers.formatDateToShow(date:date)
            }
            
            return cell
        }
        
    }
}

extension RequestDetailViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(self.isClassHourPickerSelection)
        {
            let hoursAndMinutesOfClass = [self.hoursOfClases!,["0", "30"]];
            return hoursAndMinutesOfClass[component].count
        }
        else
        {
            return self.pickerHours[component].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(self.isClassHourPickerSelection)
        {
            let hoursAndMinutesOfClass = [self.hoursOfClases!,["0", "30"]];
            return hoursAndMinutesOfClass[component][row]
        }
        else
        {
            return self.pickerHours[component][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(50.0)
    }
}
