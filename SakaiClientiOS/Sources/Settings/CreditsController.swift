//
//  CreditsController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/5/19.
//

import UIKit
import SafariServices

class CreditsController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var footerView: UIView!

    let credits: [(String, URL?)] = [
        ("Rutgers Sakai", URL(string: "https://sakai.rutgers.edu/direct/describe")),
        ("Icons8", URL(string: "https://www.icons8.com")),
        ("Alamofire", URL(string: "https://github.com/Alamofire/Alamofire")),
        ("RATreeView", URL(string: "https://github.com/Augustyniak/RATreeView")),
        ("M13Checkbox", URL(string: "https://github.com/Marxon13/M13Checkbox")),
        ("Fabric", URL(string: "https://get.fabric.io")),
        ("Wordpress-Aztec", URL(string: "https://github.com/wordpress-mobile/AztecEditor-iOS")),
        ("Gridicons", URL(string: "https://github.com/Automattic/Gridicons-iOS")),
        ("Toast-Swift", URL(string: "https://github.com/scalessec/Toast-Swift"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Credits"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: String(describing: UITableViewCell.self))
        view.backgroundColor = Palette.main.primaryBackgroundColor

        headerView.backgroundColor = Palette.main.primaryBackgroundColor
        headerLabel.backgroundColor = Palette.main.primaryBackgroundColor
        headerLabel.textColor = Palette.main.secondaryTextColor

        footerView.backgroundColor = Palette.main.primaryBackgroundColor
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: UITableViewCell.self),
            for: indexPath
        )
        let (name, _) = credits[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = Palette.main.primaryBackgroundColor
        cell.selectedBackgroundView = cell.selectedView()
        cell.textLabel?.textColor = Palette.main.primaryTextColor
        cell.textLabel?.text = name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, url) = credits[indexPath.row]
        guard let link = url else {
            return
        }
        let safariController = SFSafariViewController.defaultSafariController(url: link)
        tabBarController?.present(safariController, animated: true, completion: nil)
    }
}
