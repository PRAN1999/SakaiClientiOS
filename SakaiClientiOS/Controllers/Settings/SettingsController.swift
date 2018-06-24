//
//  AccountController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class SettingsController: UIViewController {
    
    var indicator: LoadingIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: view)
        indicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func logout(_ sender: UIButton) {
        RequestManager.shared.logout() {}
    }
}
