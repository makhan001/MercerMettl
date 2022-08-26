//
//  ValidateKeyViewModel.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

final class ValidateKeyViewModel {

    var key: String = ""
    var webUrl: String = ""

    var response: SuccessResponseModel?
    let provider: OnboardingServiceProvidable
    weak var view: OnboardingViewRepresentable?

    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }

    func validate(key: String) {
        self.key = key
        self.provider.validate(key: key)
    }
}

extension ValidateKeyViewModel: OnboardingServiceProvierDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                guard (error?.responseData?.message) != nil else {
                    self.view?.onAction(.errorMessage(AppConstant.ErrorMessage))
                    return
                }
                self.view?.onAction(.errorMessage("Invalid invitation key: \(self.key)"))
//                self.view?.onAction(.errorMessage(message))
            } else {
                if let responsevalue = response as? SuccessResponseModel {
                    print(responsevalue)
                    self.webUrl = "\(SessionDispatcher().host)/\(APIVersion.v2)/authenticateKey/\(self.key)"
                    self.view?.onAction(.validate)
                } else {
                    self.view?.onAction(.errorMessage(AppConstant.ErrorMessage))
                }
            }
        }
    }
}
