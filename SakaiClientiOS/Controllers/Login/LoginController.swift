//
//  EmailLoginController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 9/17/18.
//

import Foundation
import UIKit

/// A landing page for login with NetId or with Email
class LoginController: UIViewController {

    @IBOutlet weak var netIdButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!

    /// Callback to execute for a successful login
    var onLogin: (() -> Void)?

    override func viewDidLoad() {
        self.title = "Login"
    }

    @IBAction func loginWithNetId(_ sender: Any) {
        let loginController = LoginWebViewController(url: AppGlobals.loginUrl)
        loginController.onLogin = onLogin
        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        let loginController = LoginWebViewController(url: AppGlobals.emailLoginUrl)
        loginController.onLogin = onLogin
        self.navigationController?.pushViewController(loginController, animated: true)
    }
}
