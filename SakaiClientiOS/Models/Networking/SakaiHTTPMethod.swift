//
//  SakaiHTTPMethod.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/8/19.
//

import Foundation
import Alamofire

enum SakaiHTTPMethod {
    case get, post

    var httpMethod: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        }
    }
}
