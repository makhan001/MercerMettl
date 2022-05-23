//
//  UserTask.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation


final class UserTask {
    private let dispatcher = SessionDispatcher()
    
    func validate(key: String, completion:@escaping APIResult<SuccessResponseModel> ) {
        dispatcher.execute(requst: UserRequests(requestType: .validateKey(key)), modeling: SuccessResponseModel.self, completion:   completion)
    }
}
