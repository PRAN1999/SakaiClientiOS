//
//  ChatService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/10/19.
//

import Foundation

/// Used to submit new chat messages for a certain chat channel
struct ChatService {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func submitMessage(text: String, channelId: String?, csrf: String?, completion: @escaping () -> Void) {
        guard
            let csrftoken = csrf,
            let chatChannelId = channelId
            else {
                return
        }
        let parameters = [
            "body": text,
            "chatChannelId": chatChannelId,
            "csrftoken": csrftoken
        ]
        // The Response to the POST request is not something that can be
        // decoded, so an UndefinedResponse struct is used
        let request = SakaiRequest<UndefinedResponse>(endpoint: .newChat,
                                                      method: .post,
                                                      parameters: parameters)
        networkService.makeEndpointRequest(request: request) { _, _ in
            completion()
        }
    }
}
