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

    @IBOutlet private weak var netIdButton: UIButton!
    @IBOutlet private weak var emailButton: UIButton!

    /// Callback to execute for a successful login
    var onLogin: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
    }

    @IBAction func loginWithNetId(_ sender: Any) {
        let loginController = LoginWebViewController(loginUrl: AppGlobals.loginUrl)
        loginController.onLogin = onLogin
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        let loginController = LoginWebViewController(loginUrl: AppGlobals.emailLoginUrl)
        loginController.onLogin = onLogin
        navigationController?.pushViewController(loginController, animated: true)
    }
}
