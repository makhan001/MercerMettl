//
//  Userstore.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k on 12/05/22.
//

import Foundation

struct UserStore {
    private static let kUserAgent = "user_agent"

    static var userAgent: String? {
        return UserDefaults.standard.string(forKey: kUserAgent)
    }

    static func save(userAgent: String?) {
        UserDefaults.standard.set(userAgent, forKey: kUserAgent)
    }
}
