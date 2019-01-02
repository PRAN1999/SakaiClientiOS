//
//  NetworkService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol NetworkService {
    func makeEndpointRequest<T: Decodable>(request: SakaiRequest<T>, completion: @escaping (T?, SakaiError?) -> Void)

    func makeEndpointRequestWithoutCache<T: Decodable>(request: SakaiRequest<T>, completion: @escaping (T?, SakaiError?) -> Void)
}
