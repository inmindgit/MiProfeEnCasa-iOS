//
//  MenuViewController.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/2/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.lblEmail.text = Helpers.getLoggedUser().email
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    
    @IBAction func btnExitTap(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: Constants.UserDefaults.kIsUserLoggedIn)
        defaults.synchronize()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.changeRootViewControllerToLoginViewController()
    }
}

extension MenuViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        if(indexPath.row == 0)
        {
            cell.lblTitle.text = NSLocalizedString("REQUESTS", comment: "")
            cell.imgIcon.image = UIImage.init(named: "ic_home")
            return cell
        }
        else 
        {
            cell.lblTitle.text = NSLocalizedString("PROFILE", comment: "")
            cell.imgIcon.image = UIImage.init(named: "ic_action_user")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            let  requestListViewController = self.storyboard?.instantiateViewController(withIdentifier: "RequestListViewController") as! RequestListViewController
            let navController = UINavigationController(rootViewController: requestListViewController)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }
        else
        {
            let  profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            let navController = UINavigationController(rootViewController: profileViewController)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }
    }
}

