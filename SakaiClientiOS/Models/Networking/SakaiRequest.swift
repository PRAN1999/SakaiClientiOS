//
//  SakaiRequest.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/30/18.
//

import Foundation
import Alamofire

class SakaiRequest<T: Decodable> {

    let endpoint: SakaiEndpoint
    let method: HTTPMethod

    init(endpoint: SakaiEndpoint, method: HTTPMethod) {
        self.endpoint = endpoint
        self.method = method
    }
}
