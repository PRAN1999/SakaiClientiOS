//
//  SettingsController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/3/19.
//

import UIKit
import SafariServices

class SettingsController: UITableViewController {

    private let aboutURL = URL(string: "https://www.google.com")
    private let privacyURL = URL(string: "https://www.google.com")

    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var tableFooter: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoCreditLabel: UILabel!

    enum AppInfo {
        case about, privacy, thanks

        var description: String {
            switch self {
            case .about:
                return "About"
            case .privacy:
                return "Privacy Policy"
            case .thanks:
                return "Thanks"
            }
        }

        var icon: String {
            switch self {
            case .about:
                return AppIcons.infoIcon
            case .privacy:
                return AppIcons.privacyIcon
            case .thanks:
                return AppIcons.thanksIcon
            }
        }
    }

    let infoArr: [AppInfo] = [.about, .privacy, .thanks]

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

        UIButton.roundButton(button: logoutButton)
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
