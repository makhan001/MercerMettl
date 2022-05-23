//
//  APIProvider.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

import Foundation

final class OnboardingServiceProvider: OnboardingServiceProvidable {
    var delegate: OnboardingServiceProvierDelegate?
    private let task = UserTask()
    
    func validate(key: String) {
        self.task.validate(key: key) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .validate, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .validate, with: resp, with: nil)
        }
    }
}
