//
//  APIParser.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

public struct Parser<T: Decodable> {
    static func from(_ data: Data) -> (T?, Error?) {
        do {
            let decodedModel = try JSONDecoder().decode(T.self, from: data)
            return (decodedModel, nil)
        } catch {
            print("Codable error === \(error)")
            return (nil, error)
        }
    }
    static func from(_ data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
    static func to<T: Encodable>(_ model: T) -> (Data?, Error?) {
        do { return (try JSONEncoder().encode(model), nil) } catch { return (nil, error) }
    }
    static func to<T: Encodable>(_ model: T) -> Data? {
        return try? JSONEncoder().encode(model)
    }
}
