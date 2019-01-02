//
//  DownloadService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol DownloadService {
    /// Download the data at a remote URL to the Documents directory for the app, and callback with
    /// the location of the downloaded item
    ///
    /// - Parameters:
    ///   - url: the URL to download data from
    ///   - completion: a completion handler to call with the location of the downloaded file
    func downloadToDocuments(url: URL, completion: @escaping (_ fileDestination: URL?) -> Void)
}
