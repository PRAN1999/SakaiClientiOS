//
//  NetworkService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol NetworkService {

    typealias DecodableResponse<T> = (T?, SakaiError?) -> Void

    func makeEndpointRequest<T: Decodable>(request: SakaiRequest<T>,
                                           completion: @escaping DecodableResponse<T>)

    func makeEndpointRequestWithoutCache<T: Decodable>(request: SakaiRequest<T>,
                                                       completion: @escaping DecodableResponse<T>)
}
