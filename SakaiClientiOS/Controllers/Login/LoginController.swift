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
    @IBOutlet weak var stackView: UIStackView!

    /// Callback to execute for a successful login
    var onLogin: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.main.primaryBackgroundColor

        roundButton(button: netIdButton)
        roundButton(button: emailButton)

        title = "Login"
    }

    private func roundButton(button: UIButton) {

        button.backgroundColor = Palette.main.highlightColor
        button.titleLabel?.textColor = Palette.main.primaryTextColor

        button.layer.cornerRadius = 10
        button.layer.borderColor = Palette.main.borderColor.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
    }

    @IBAction func loginWithNetId(_ sender: Any) {
        let loginController = LoginWebViewController(loginUrl: LoginConfiguration.loginUrl)
        loginController.onLogin = onLogin
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        let loginController = LoginWebViewController(loginUrl: LoginConfiguration.emailLoginUrl)
        loginController.onLogin = onLogin
        navigationController?.pushViewController(loginController, animated: true)
    }
}
