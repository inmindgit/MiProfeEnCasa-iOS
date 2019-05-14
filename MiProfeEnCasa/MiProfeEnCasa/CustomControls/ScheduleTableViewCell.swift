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
    @IBOutlet weak var lblStartingDateTooltip: UILabel!
    
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
                self.lblPendingRequest.text = NSLocalizedString("PAYMENT_ACCPETANCE_BY_STUDENT", comment: "")
            }
            else
            {
                self.lblPendingRequest.text = NSLocalizedString("PAYMENT_ACCEPTANCE", comment: "")
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
                self.btnLoadTimeOrAddReport.setTitle(NSLocalizedString("LOAD_TIME", comment: ""), for: .normal)
            }
            else
            {
                self.btnLoadTimeOrAddReport.setTitle(NSLocalizedString("LOAD_REPORT", comment: ""), for: .normal)
            }
            
        }
    }
    
    fileprivate func selectedSegmentioIndex() -> Int {
        return 0
    }
    
    fileprivate func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: NSLocalizedString("MONDAY", comment: ""), image:nil),
            SegmentioItem(title: NSLocalizedString("TUESDAY", comment: ""), image:nil),
            SegmentioItem(title: NSLocalizedString("WEDNESDAY", comment: ""), image:nil),
            SegmentioItem(title: NSLocalizedString("THURSDAY", comment: ""), image:nil),
            SegmentioItem(title: NSLocalizedString("FRIDAY", comment: ""), image:nil),
            SegmentioItem(title: NSLocalizedString("SATURDAY", comment: ""), image:nil),
            SegmentioItem(title: NSLocalizedString("SUNDAY", comment: ""), image:nil)
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
    
    func manageTableViewItems(schedule: [ScheduleModel]) -> Int
    {
        self.displayedAvailableTimes = schedule
        if(schedule.count == 0)
        {
             tableView.setEmptyView(title: NSLocalizedString("NO_TIME_AVAILABLE", comment: ""))
            return 0
        }
        else
        {
            tableView.restore()
            return schedule.count
        }
    }
}

extension ScheduleTableViewCell : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(daysSegmentedController.selectedSegmentioIndex == Days.kMonday)
        {
            return self.manageTableViewItems(schedule: self.mondayAvailableTimes)
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kTuesday)
        {
            return self.manageTableViewItems(schedule: self.tuesdayAvailableTimes)
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kWednesday)
        {
            return self.manageTableViewItems(schedule: self.wednesdayAvailableTimes)
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kThursday)
        {
            return self.manageTableViewItems(schedule: self.thursdayAvailableTimes)
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kFriday)
        {
            return self.manageTableViewItems(schedule: self.fridayAvailableTimes)
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kSaturday)
        {
            return self.manageTableViewItems(schedule: self.saturdayAvailableTimes)
        }
        else if(daysSegmentedController.selectedSegmentioIndex == Days.kSunday)
        {
            return self.manageTableViewItems(schedule: self.sundayAvailableTimes)
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
        
        cell.lblTime.text = self.displayedAvailableTimes[indexPath.row].horarioComienzo! + "    -    " + self.displayedAvailableTimes[indexPath.row].horarioFin!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


