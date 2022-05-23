//
//  APIAdaptables.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

enum OnboardingAction {
    case validate
    case sessionExpired
    case requireFields(_ text :String)
    case errorMessage(_ text: String)
}
protocol OnboardingViewRepresentable: AnyObject {
    func onAction(_ action: OnboardingAction)
}
protocol OnboardingServiceProvidable: AnyObject {
    var delegate: OnboardingServiceProvierDelegate? { get set }
    func validate(key: String)
}
protocol OnboardingServiceProvierDelegate:AnyObject {
    func completed<T>(for action:OnboardingAction, with response:T?, with error:APIError?)
}
