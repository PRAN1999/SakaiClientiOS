//
//  FilterViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/22/18.
//

import UIKit
import M13Checkbox

/// Modal Filter used to switch Assignment sorting
class FilterViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var selectedIndex = 0

    /// Callback for when a filter has been chosen and should be applied. It
    /// is possible onSet will be called with the same filter that was
    /// already set. It is the presenter's responsibility to handle that
    /// appropriately
    var onSet: ((Int) -> Void)?

    /// When a new filter should not be applied
    var onCancel: (() -> Void)?

    var filters: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        roundView(view: popupView)

        tableView.register(CheckBoxCell.self, forCellReuseIdentifier: CheckBoxCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }

    private func roundView(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }

    @IBAction func setFilter(_ sender: Any) {
        onSet?(selectedIndex)
    }

    @IBAction func cancel(_ sender: Any) {
        onCancel?()
    }
}

extension FilterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CheckBoxCell.reuseIdentifier,
            for: indexPath) as? CheckBoxCell else {
                return UITableViewCell()
        }
        cell.label.text = filters[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.checkBox.setCheckState(.checked, animated: false)
        } else {
            cell.checkBox.setCheckState(.unchecked, animated: false)
        }
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == indexPath.row {
            return
        }
        let oldIndex = IndexPath(row: selectedIndex, section: 0)
        selectedIndex = indexPath.row
        guard let cell = tableView.cellForRow(at: indexPath) as? CheckBoxCell else {
            return
        }
        cell.checkBox.setCheckState(.checked, animated: true)
        guard let oldCell = tableView.cellForRow(at: oldIndex) as? CheckBoxCell else {
            
            return
        }
        oldCell.checkBox.setCheckState(.unchecked, animated: true)
    }
}
