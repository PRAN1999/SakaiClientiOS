//
//  NetworkController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/13/18.
//

import ReusableSource

extension NetworkController where Self:UIViewController {
    
    func loadSource(completion: @escaping () -> Void) {
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        networkSource.loadDataSource {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            completion()
        }
    }
    
    func loadSourceWithoutCache(completion: @escaping () -> Void) {
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        networkSource.loadDataSourceWithoutCache {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            completion()
        }
    }
}
