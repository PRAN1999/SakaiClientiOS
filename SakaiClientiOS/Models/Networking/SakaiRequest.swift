//
//  SakaiRequest.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/30/18.
//

import Foundation
import Alamofire

struct SakaiRequest<T: Decodable> {

    let endpoint: SakaiEndpoint
    let method: HTTPMethod
    let parameters: [String: Any]?

    init(endpoint: SakaiEndpoint,
         method: SakaiHTTPMethod,
         parameters: [String: Any]? = nil) {
        self.endpoint = endpoint
        self.method = method.httpMethod
        self.parameters = parameters
    }
}
