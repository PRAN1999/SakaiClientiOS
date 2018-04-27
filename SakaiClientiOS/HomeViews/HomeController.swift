//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: UITableViewController {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    //Resets Alamofire default session on initial view load
    //Temporary measure for debugging purposes - 4/24/18 - PN
    override func viewDidLoad() {
        title = "Home"
        RequestManager.getSites(completion: { siteList in
            for site in siteList! {
                site.printSite()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        //sideConstraint.constant = -221
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
