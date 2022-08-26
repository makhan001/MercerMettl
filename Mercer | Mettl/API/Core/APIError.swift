//
//  APIError.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

struct APIErroResponseData: Codable {
    let message: String?
    let error: String?
    static func from(data: Data) -> APIErroResponseData? {
        return try? JSONDecoder().decode(APIErroResponseData.self, from: data)
    }
}

public struct APIError: Error {
    let errorCode: ErrorCode
    var responseData: APIErroResponseData?
    var statusCode: Int
}

public enum ErrorCode {
    case badRequest
    case uknown
    case network
    case server
    case authorize
    case parsing
}
