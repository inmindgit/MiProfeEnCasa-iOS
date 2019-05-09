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
    var requestList: RequestListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.tableView.register(UINib(nibName: "RequestListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")// register cell name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        self.title = "Solicitudes"
        
        self.setupMenu()
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
    
    func getRequestList()
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
                    self.tableView.reloadData()
                }
            }
            else
            {}
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
        cell.lblAddress.text = "Prueba: " + (self.requestList?.result?[indexPath.row].UdireccionCalle)!
        cell.lblDescription.text = self.requestList?.result?[indexPath.row].Cdescripcion
        
        if let date = self.requestList?.result?[indexPath.row].SAfechaInicio
        {
            cell.lblStartingDate.text = "Incio propuesto: " + Helpers.formatDateToShow(date:date)
        }
        
        if let date = self.requestList?.result?[indexPath.row].SAfechaPrueba
        {
            cell.lblTestDate.text = "Incio propuesto: " + Helpers.formatDateToShow(date:date)
        }
        
        cell.lblAmountOfClasesPerWeek.text = "Veces por semana: " +  String(self.requestList?.result?[indexPath.row].SAvecesPorSemana ?? 0)
        
        cell.imgIcon.image = UIImage.init(named: Helpers.getRequestStatusImageName(requestStatus: (self.requestList?.result?[indexPath.row].estadoSolicitudMaestroId)!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let  requestDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RequestDetailViewController") as! RequestDetailViewController
        requestDetailViewController.request = self.requestList?.result![indexPath.row]
        self.navigationController?.pushViewController(requestDetailViewController, animated: true)
    }
}
