//
//  RequestListViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 4/30/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit
import SWRevealViewController

class RequestListViewController: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    private let refreshControl = UIRefreshControl()
    var requestList: RequestListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.tableView.register(UINib(nibName: "RequestListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.getRequestListByRefresh), for: .valueChanged)
        
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("REQUESTS", comment: "")

        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceTokenAssociation), name: Notification.Name("FCMToken"), object: nil)
    
        self.setupMenu()
        if Helpers.tokenIdForPushNofifications != nil
        {
            self.deviceTokenAssociation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRequestList()
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
            self.tableView.isUserInteractionEnabled = true
        } else {
            self.tableView.isUserInteractionEnabled = false
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == .left) {
            self.tableView.isUserInteractionEnabled = true
        } else {
            self.tableView.isUserInteractionEnabled = false
        }
    }
    
    @objc func getRequestListByRefresh()
    {
        ApiManager.sharedInstance.showHud = false
        self.getRequestList()
    }
    
    @objc func getRequestList()
    {
        ApiManager.sharedInstance.execute(type: RequestListModel.self, operation: "get") { (response:AnyObject?) in
            if((response) != nil)
            {
                if response is NSError
                {
                    // Por ahora no hago nada si falla
                }
                else if response is RequestListModel {
                    self.requestList = response as? RequestListModel
                    ApiManager.sharedInstance.showHud = true
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    if self.requestList != nil && self.requestList?.result?.count ?? 0 > 0
                    {
                        self.tableView.backgroundView = nil
                        
                    }
                    else
                    {
                        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height));
                        let messageLabel = UILabel(frame: rect);
                        messageLabel.text = "No existen solicitudes";
                        messageLabel.textColor = UIColor.black;
                        messageLabel.numberOfLines = 0;
                        messageLabel.textAlignment = .center;
                        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
                        messageLabel.sizeToFit()

                        self.tableView.backgroundView = messageLabel;
                        
                        self.tableView.separatorStyle = .none;
                    }
                   
                }
            }
            else
            {}
        }
    }
    
    @objc func deviceTokenAssociation()
    {
        if let token = Helpers.tokenIdForPushNofifications
        {
            ApiManager.sharedInstance.queryParameters = "usuarioId=" + String(Helpers.getLoggedUser()._id ?? 0) + "&token=" + Helpers.getStringParameter(parameter: token)
            ApiManager.sharedInstance.execute(type: DeviceTokenAssociationModel.self, operation: "post") { (response:AnyObject?) in
                if((response) != nil)
                {
                    if response is NSError
                    {}
                    else if response is DeviceTokenAssociationModel {
                        if((response as! DeviceTokenAssociationModel).code == 1)
                        {}
                        else
                        {
                        }
                    }
                }
                else
                {}
            }
        }
    }
}

extension RequestListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(requestList == nil)
        {
            return 0
        }
        else
        {
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return (self.requestList?.result?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RequestListTableViewCell
        cell.lblCourse.text = self.requestList?.result?[indexPath.row].Cnombre
        cell.lblAddress.text = (self.requestList?.result?[indexPath.row].UdireccionCalle)!
        cell.lblDescription.text = self.requestList?.result?[indexPath.row].Cdescripcion
        
        
        if let date = self.requestList?.result?[indexPath.row].SAfechaInicio
        {
            if(self.requestList?.result?[indexPath.row].estadoSolicitudMaestroId == Constants.RequestStatus.kRequestPreAccepted || self.requestList?.result?[indexPath.row].estadoSolicitudMaestroId == Constants.RequestStatus.kRequestAccepted)
            {
                if(self.requestList?.result?[indexPath.row].estadoSolicitudMaestroId == Constants.RequestStatus.kRequestPreAccepted)
                {
                    cell.lblStartingDate.text = NSLocalizedString("START_CLASS_PROPOSAL", comment: "")
                }
                else
                {
                    cell.lblStartingDate.text = NSLocalizedString("START_CLASS", comment: "")
                }
                
                cell.lblStartingDate.text = cell.lblStartingDate.text! + Helpers.formatDateToShow(date:(self.requestList?.result?[indexPath.row].claseFecha)!) + " " + (self.requestList?.result?[indexPath.row].claseHorario)!
            }
            else
            {
                cell.lblStartingDate.text = NSLocalizedString("START_CLASS", comment: "") + Helpers.formatDateToShow(date:date)
            }
        }
        
        if let date = self.requestList?.result?[indexPath.row].SAfechaPrueba
        {
            cell.lblTestDate.text = NSLocalizedString("TEST_DATE", comment: "") + Helpers.formatDateToShow(date:date)
        }
        
        cell.lblAmountOfClasesPerWeek.text = NSLocalizedString("CLASSES_PER_WEEK", comment: "") +  String(self.requestList?.result?[indexPath.row].SAvecesPorSemana ?? 0)
        
        cell.imgIcon.image = UIImage.init(named: Helpers.getRequestStatusImageName(requestStatus: (self.requestList?.result?[indexPath.row].estadoSolicitudMaestroId)!))
        
        if(self.requestList?.result?[indexPath.row].SAnoPresencial == 1)
        {
            cell.imgSkype.image = UIImage.init(named:"ic_skype")
        }
        else
        {
            cell.imgSkype.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Helpers.requestId = String(self.requestList?.result?[indexPath.row]._id ?? 0)
        ApiManager.sharedInstance.execute(type: RequestDetailModel.self, operation: "get") { (response:AnyObject?) in
            if((response) != nil)
            {
                if response is NSError
                {}
                else if response is RequestDetailModel {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    let  requestDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RequestDetailViewController") as! RequestDetailViewController
                    requestDetailViewController.request = self.requestList?.result![indexPath.row]
                    self.navigationController?.pushViewController(requestDetailViewController, animated: true)
                }
            }
            else
            {}
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
}
