//
//  ReusableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension ReusableController where Self:UIViewController {
    func loadTableSource() {
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        reusableSource.loadDataSourceWithoutCache {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            print("Loaded")
        }
    }
}
