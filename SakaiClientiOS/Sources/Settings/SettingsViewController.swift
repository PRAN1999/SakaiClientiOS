//
//  SettingsViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/3/19.
//

import UIKit
import SafariServices
import MessageUI

class SettingsViewController: UITableViewController {

    private let aboutURL = URL(string: "https://rutgerssakai.github.io/SakaiMobile/")
    private let privacyURL = URL(string: "https://rutgerssakai.github.io/SakaiMobile/privacy.html")

    private let appID = 1435278106
    private lazy var rateUrl = "https://itunes.apple.com/us/app/rutgers-sakai-mobile/id\(appID)?mt=8&action=write-review"

    private let developerEmail = "rutgerssakaiapp@gmail.com"

    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var tableFooter: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoCreditLabel: UILabel!

    let infoArr = AppSettings.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.register(SiteCell.self,
                           forCellReuseIdentifier: SiteCell.reuseIdentifier)
        view.backgroundColor = Palette.main.primaryBackgroundColor
        tableHeader.backgroundColor = Palette.main.primaryBackgroundColor
        tableFooter.backgroundColor = Palette.main.primaryBackgroundColor

        imageHeader.backgroundColor = Palette.main.primaryBackgroundColor
        versionLabel.backgroundColor = Palette.main.primaryBackgroundColor
        versionLabel.textColor = Palette.main.primaryTextColor
        imageHeader.image = UIImage(named: "AppIcon60x60")
        logoCreditLabel.backgroundColor = Palette.main.primaryBackgroundColor
        logoCreditLabel.textColor = Palette.main.secondaryTextColor

        logoutButton.round()
        logoutButton.tintColor = Palette.main.primaryTextColor
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            return UITableViewCell()
        }
        let info = infoArr[indexPath.row]
        cell.iconLabel.font = UIFont(name: AppIcons.generalIconFont, size: 25.0)
        cell.titleLabel.text = info.description
        cell.iconLabel.text = info.icon
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = infoArr[indexPath.row]
        switch item {
        case .about:
            presentSafariController(url: aboutURL)
        case .privacy:
            presentSafariController(url: privacyURL)
        case .thanks:
            let storyboard = UIStoryboard(name: "SettingsView", bundle: nil)
            let creditsController = storyboard.instantiateViewController(withIdentifier: "credits")
            navigationController?.pushViewController(creditsController, animated: true)
        case .contact:
            if !MFMailComposeViewController.canSendMail() {
                presentErrorAlert(string: "Mail Services not available. Our email is \(developerEmail)")
            } else {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self

                // Configure the fields of the interface.
                composeVC.setToRecipients([developerEmail])
                composeVC.setSubject("Feedback")

                tabBarController?.present(composeVC, animated: true, completion: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        case .rate:
            if let url = URL(string: rateUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                presentErrorAlert(string: "Cannot leave rating at this time. Please go directly to the App Store")
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private func presentSafariController(url: URL?) {
        guard let url = url else {
            return
        }
        let safariController = SFSafariViewController.defaultSafariController(url: url)
        tabBarController?.present(safariController, animated: true, completion: nil)
    }

    @IBAction func logout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.logout()
    }

}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        tabBarController?.dismiss(animated: true, completion: nil)
    }
}
