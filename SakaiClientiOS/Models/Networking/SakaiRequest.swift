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
    let parameters: Parameters?

    init(endpoint: SakaiEndpoint, method: HTTPMethod, parameters: Parameters? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
    }
}
