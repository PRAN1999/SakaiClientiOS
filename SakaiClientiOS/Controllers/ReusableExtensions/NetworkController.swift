//
//  ReusableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension NetworkController where Self:UIViewController {
    func loadSource() {
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        networkSource.loadDataSourceWithoutCache {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            print("Loaded")
        }
    }
}
