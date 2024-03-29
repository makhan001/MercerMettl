//
//  APIResponder.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

protocol RequestRepresentable {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var headers: [String: String]? { get }
}

extension RequestRepresentable {
    var headers: [String: String]? { return nil   }
    var method: HTTPMethod { return .post  }
    var parameters: Parameters { return .none }

    func encodeBody<T: Codable>(data: T) -> Data? {
        let data = try? JSONEncoder().encode(data.self)
        return data
    }

    func encode(body: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
    }

    func encode(body: Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
    }
}

public enum Response<T: Decodable> {
    case success(date: T)
    case failed(error: APIError)
}
