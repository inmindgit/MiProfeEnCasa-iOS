//
//  ScheduleTableViewCell.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/8/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit
import Segmentio

private struct Days
{
    static let kMonday = 0
    static let kTuesday = 1
    static let kWednesday = 2
    static let kThursday = 3
    static let kFriday = 4
    static let kSaturday = 5
    static let kSunday = 6
}

protocol ScheduleTableViewCellDelegate {
    func loadTimeOrAddReport()
    func selectClassHours(classesOfDay : [ScheduleModel], index : Int)
}

class ScheduleTableViewCell: UITableViewCell, TimePeriodTableViewCellDelegate {
    @IBOutlet weak var daysSegmentedController: Segmentio!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var daysSegmentedControlHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnLoadTimeOrAddReport: UIButton!
    @IBOutlet weak var lblPendingRequest: UILabel!
    @IBOutlet weak var lblPendingRequestHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTestDate: UILabel!
    @IBOutlet weak var lblStartingDate: UILabel!
    
    var mondayAvailableTimes = [ScheduleModel]()
    var tuesdayAvailableTimes = [ScheduleModel]()
    var wednesdayAvailableTimes = [ScheduleModel]()
    var thursdayAvailableTimes = [ScheduleModel]()
    var fridayAvailableTimes = [ScheduleModel]()
    var saturdayAvailableTimes = [ScheduleModel]()
    var sundayAvailableTimes = [ScheduleModel]()
    
    var displayedAvailableTimes = [ScheduleModel]()
    
    var segmentioStyle = SegmentioStyle.onlyLabel
    var request: RequestModel?
    
    var delegate: ScheduleTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        self.tableView.register(UINib(nibName: "TimePeriodTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupSegmentioView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func setupSegmentioView() {
        daysSegmentedController.setup(
            content: segmentioContent(),
            style: segmentioStyle,
            options: segmentioOptions()
        )
        
        daysSegmentedController.selectedSegmentioIndex = selectedSegmentioIndex()
        daysSegmentedController.valueDidChange = { [weak self] _, segmentIndex in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func btnLoadTimeOrAddReportTap(_ sender: Any) {
        delegate?.loadTimeOrAddReport()
    }
    
    func setClassHour(index: Int) {
        self.delegate?.selectClassHours(classesOfDay:self.displayedAvailableTimes, index: index)
    }
    
    func hideControls(requestStatus: Int)
    {
        if(requestStatus == Constants.RequestStatus.kRequestNotReaded || requestStatus == Constants.RequestStatus.kRequestReaded)
        {
            self.btnLoadTimeOrAddReport.isUserInteractionEnabled = false
            self.btnLoadTimeOrAddReport.isHidden = true
            self.lblPendingRequest.isHidden = true
        }
        else if(requestStatus == Constants.RequestStatus.kRequestPreAccepted || requestStatus == Constants.RequestStatus.kRequestPendingPayment)
        {
            self.daysSegmentedController.isUserInteractionEnabled = false
            self.daysSegmentedController.isHidden = true
            self.btnLoadTimeOrAddReport.isHidden = true
            self.tableView.isHidden = true
            self.tableViewHeightConstraint.constant = 0
            
            if(requestStatus == Constants.RequestStatus.kRequestPreAccepted)
            {
                self.lblPendingRequest.text = "Pendiente de aceptación del alumno"
            }
            else
            {
                self.lblPendingRequest.text = "Pago pendiente de aceptación"
            }
        }
        else if(requestStatus == Constants.RequestStatus.kRequestAccepted || requestStatus == Constants.RequestStatus.kRequestEnded)
        {
            self.daysSegmentedController.isUserInteractionEnabled = false
            self.daysSegmentedController.isHidden = true
            self.lblPendingRequest.isHidden = true
            self.tableView.isHidden = true
            self.tableViewHeightConstraint.constant = 0
            
            if(requestStatus == Constants.RequestStatus.kRequestAccepted)
            {
                self.btnLoadTimeOrAddReport.setTitle("CARGAR HORAS", for: .normal)
            }
            else
            {
                self.btnLoadTimeOrAddReport.setTitle("INGRESAR INFORME", for: .normal)
            }
            
        }
    }
    
    fileprivate func selectedSegmentioIndex() -> Int {
        return 0
    }
    
    
    fileprivate func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "L", image:nil),
            SegmentioItem(title: "M", image:nil),
            SegmentioItem(title: "M", image:nil),
            SegmentioItem(title: "J", image:nil),
            SegmentioItem(title: "V", image:nil),
            SegmentioItem(title: "S", image:nil),
            SegmentioItem(title: "D", image:nil)
        ]
    }
    
    
    
    fileprivate func segmentioOptions() -> SegmentioOptions {
        return SegmentioOptions(
            backgroundColor: UIColor(red: 0, green: 168.0/255.0, blue: 135.0/255.0, alpha: 1) ,
            segmentPosition: .fixed(maxVisibleItems: 7),
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: UIView.ContentMode.center,
            labelTextAlignment: NSTextAlignment.center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates(),
            animationDuration: 0.1
        )
    }
    
    fileprivate func segmentioStates() -> SegmentioStates {
        let font = UIFont(name: "Helvetica-Bold", size: 13)
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor(red: 0, green: 168.0/255.0, blue: 135.0/255.0, alpha: 1) ,
                titleFont: font!,
                titleTextColor: .lightGray
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor(red: 0, green: 168.0/255.0, blue: 135.0/255.0, alpha: 1) ,
                titleFont: font!,
                titleTextColor: .white
            ),
            highlightedState: segmentioState(
                backgroundColor: UIColor(red: 0, green: 168.0/255.0, blue: 135.0/255.0, alpha: 1) ,
                titleFont: font!,
                titleTextColor: .white
            )
        )
    }
    
    fileprivate func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(backgroundColor: backgroundColor, titleFont: titleFont, titleTextColor: titleTextColor)
    }
    
    fileprivate func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 1, color: .white)
    }
    
    fileprivate func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0, color: .white)
    }
    
    fileprivate func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(ratio: 1, color: UIColor(red: 0, green: 168.0/255.0, blue: 135.0/255.0, alpha: 1))
    }
    
    func sortAvailableTimesPerDay(request: RequestModel?)
    {
        for availableTime in (request?.horarios)!
        {
            if(availableTime.dia == Days.kMonday)
            {
                mondayAvailableTimes.append(availableTime)
            }
            else if(availableTime.dia == Days.kTuesday)
            {
                tuesdayAvailableTimes.append(availableTime)
            }
            else if(availableTime.dia == Days.kWednesday)
            {
                wednesdayAvailableTimes.append(availableTime)
            }
            else if(availableTime.dia == Days.kThursday)
            {
                thursdayAvailableTimes.append(availableTime)
            }
            else if(availableTime.dia == Days.kFriday)
            {
                fridayAvailableTimes.append(availableTime)
            }
            else if(availableTime.dia == Days.kSaturday)
            {
                saturdayAvailableTimes.append(availableTime)
            }
            else if(availableTime.dia == Days.kSunday)
            {
                sundayAvailableTimes.append(availableTime)
            }
        }
    }
}

extension ScheduleTableViewCell : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(daysSegmentedController.selectedSegmentioIndex == Days.kMonday)
        {
            self.displayedAvailableTimes = self.mondayAvailableTimes
            if(mondayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return mondayAvailableTimes.count
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kTuesday)
        {
            self.displayedAvailableTimes = self.tuesdayAvailableTimes
            if(tuesdayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return tuesdayAvailableTimes.count
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kWednesday)
        {
            self.displayedAvailableTimes = self.wednesdayAvailableTimes
            if(wednesdayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return wednesdayAvailableTimes.count
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kThursday)
        {
            self.displayedAvailableTimes = self.thursdayAvailableTimes
            if(thursdayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return thursdayAvailableTimes.count
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kFriday)
        {
            self.displayedAvailableTimes = self.fridayAvailableTimes
            if(fridayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return fridayAvailableTimes.count
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kSaturday)
        {
            self.displayedAvailableTimes = self.saturdayAvailableTimes
            if(saturdayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return saturdayAvailableTimes.count
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kSunday)
        {
            self.displayedAvailableTimes = self.sundayAvailableTimes
            if(sundayAvailableTimes.count == 0)
            {
                tableView.setEmptyView(title: "No hay horarios para este dia")
            }
            else
            {
                tableView.restore()
            }
            
            return sundayAvailableTimes.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimePeriodTableViewCell
        cell.delegate = self
        cell.index = indexPath.row
        
        if(daysSegmentedController.selectedSegmentioIndex == Days.kMonday)
        {
            cell.lblTime.text = mondayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + mondayAvailableTimes[indexPath.row].horarioFin!
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kTuesday)
        {
            cell.lblTime.text = tuesdayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + tuesdayAvailableTimes[indexPath.row].horarioFin!
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kWednesday)
        {
            cell.lblTime.text = wednesdayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + wednesdayAvailableTimes[indexPath.row].horarioFin!
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kThursday)
        {
            cell.lblTime.text = thursdayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + thursdayAvailableTimes[indexPath.row].horarioFin!
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kFriday)
        {
            cell.lblTime.text = fridayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + fridayAvailableTimes[indexPath.row].horarioFin!
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kSaturday)
        {
            cell.lblTime.text = saturdayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + saturdayAvailableTimes[indexPath.row].horarioFin!
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kSunday)
        {
            cell.lblTime.text = sundayAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + sundayAvailableTimes[indexPath.row].horarioFin!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


