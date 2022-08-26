//
//  UserRequests.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

struct UserRequests: RequestRepresentable {

    let requestType: RequestType
    enum RequestType {
        case validateKey(_ key: String)
    }

    init(requestType: RequestType) {
        self.requestType = requestType
    }

    var method: HTTPMethod {
        return .post
    }

    var endpoint: String {
        switch self.requestType {
        case let .validateKey(key):
            return "schedule/\(key)/validate"
        }
    }

    var parameters: Parameters {
        return .none
    }
}
