//
//  APIResponse.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

struct SuccessResponseModel: Codable {
    var assessmentID: Int?
    var assessmentName: String?
    var clientThemeInfo: ClientThemeInfo?
    var assessmentLanguage: AssessmentLanguage?
    var error, errorType: JSONNull?

    enum CodingKeys: String, CodingKey {
        case assessmentID = "assessmentId"
        case assessmentName, clientThemeInfo, assessmentLanguage, error, errorType
    }
}

// MARK: - AssessmentLanguage
struct AssessmentLanguage: Codable {
    var direction, language: String?
}

// MARK: - ClientThemeInfo
struct ClientThemeInfo: Codable {
    var clientID: Int?
    var clientURL: JSONNull?
    var removeMettlBranding, allowClientTheme: Bool?
    var clientThemePath, clientThemeJSON: JSONNull?
    var logoPath, feviconPath, testBackgroundImagePath: String?
    var primarySupportNumber, secondarySupportNumber: JSONNull?

    enum CodingKeys: String, CodingKey {
        case clientID = "clientId"
        case clientURL = "clientUrl"
        case removeMettlBranding, allowClientTheme, clientThemePath, feviconPath, testBackgroundImagePath, clientThemeJSON, logoPath, primarySupportNumber, secondarySupportNumber
    }
}
