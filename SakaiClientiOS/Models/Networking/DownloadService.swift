//
//  DownloadService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol DownloadService {
    /// Download the data at a remote URL to the Documents directory for the
    /// app, and callback with the location of the downloaded item
    ///
    /// - Parameters:
    ///   - url: the URL to download data from
    ///   - completion: a completion handler to call with the location of
    ///                 the downloaded file
    func downloadToDocuments(
        url: URL,
        completion: @escaping (_ fileDestination: URL?) -> Void
    )
}

extension FileManager {
    func clearDocumentsDirectory() {
        do {
            guard
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory,
                                                             in: .userDomainMask).first
                else {
                    return
            }
            let documentDirectory = try contentsOfDirectory(atPath: documentsUrl.path)
            try documentDirectory.forEach { file in
                let fileUrl = documentsUrl.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch let err {
            // TODO handle appropriately
            print(err)
            return
        }
    }
}
