//
//  FilterViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/22/18.
//

import UIKit
import M13Checkbox

class FilterViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var dateBox: M13Checkbox!
    @IBOutlet weak var classBox: M13Checkbox!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var classButton: UIButton!

    lazy var filters = [(classBox, 0), (dateBox, 1)]

    var selectedIndex = 0

    var onSet: ((Int) -> Void)?
    var onCancel: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        roundView(view: popupView)

        dateBox.stateChangeAnimation = .fill
        classBox.stateChangeAnimation = .fill

        filters[selectedIndex].0?.setCheckState(.checked, animated: true)

        classButton.addBorder(toSide: .bottom, withColor: UIColor.lightText, andThickness: 1.0)
        dateButton.addBorder(toSide: .top, withColor: UIColor.lightText, andThickness: 1.0)
    }

    private func roundView(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }

    @IBAction func didSelectClass(_ sender: Any) {
        selectedIndex = 0
        dateBox.setCheckState(.unchecked, animated: true)
        classBox.setCheckState(.checked, animated: true)
    }


    @IBAction func didSelectDate(_ sender: Any) {
        selectedIndex = 1
        classBox.setCheckState(.unchecked, animated: true)
        dateBox.setCheckState(.checked, animated: true)
    }

    @IBAction func setFilter(_ sender: Any) {
        onSet?(selectedIndex)
    }

    @IBAction func cancel(_ sender: Any) {
        onCancel?()
    }
}
