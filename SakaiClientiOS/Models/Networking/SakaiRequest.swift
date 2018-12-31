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
}
