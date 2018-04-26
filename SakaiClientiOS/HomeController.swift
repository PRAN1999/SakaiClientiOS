//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit
import Alamofire
import MaterialComponents.MaterialCollections

class HomeController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var seeThroughButton: UIButton!
    @IBOutlet weak var sideConstraint: NSLayoutConstraint!
    
    var menuShown:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    //Resets Alamofire default session on initial view load
    //Temporary measure for debugging purposes - 4/24/18 - PN
    override func viewDidLoad() {
        title = "Home"
    }
    
    override func viewDidLayoutSubviews() {
        //sideConstraint.constant = -221
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        RequestManager.isLoggedIn(completion: {flag in
            print("completion")
            if(!flag) {
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            }
        })
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Print cookies for debugging purposes - 4/24/18 - PN
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if menuShown {
            hideMenu()
        } else {
            showMenu()
        }
        menuShown = !menuShown
    }
    
    @IBAction func screenButtonTapped(_ sender: Any) {
        hideMenu()
    }
    
    func showMenu() {
        //self.sideConstraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.sideMenuView.alpha = 1
            self.seeThroughButton.alpha = 1
        })
    }
    
    func hideMenu() {
        //self.sideConstraint.constant = -221
        UIView.animate(withDuration: 0.5, animations: {
            self.sideMenuView.alpha = 0
            self.seeThroughButton.alpha = 0
        })
    }
}
