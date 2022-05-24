//
//  StringConstant.swift
//  Mercer | Mettl
//
//  Created by m@k on 15/04/22.
//

import UIKit
import Foundation

class AppConstant: NSObject {
    // MARK: -  App Constant
    static let bypassPath = "/mettlMercerRRMobileApp=true"
    
    // MARK: -  Alert & Error Messages
    static let emptyInvitationKey = "Please enter a valid Invitation Key"
    static let incorrectInvitationKey = "Invalid Invitation Key. Please Verify the Key and try again."
    
    // MARK: - Landing View Constants
    static let title1 = " Next-Gen Platform"
    static let subTitle1 = "Take Mercer | Mettl assessments on the go or from the comfort of your space on our next-generation platform."
    
    static let title2 = "Superior Test Experience"
    static let subTitle2 = "Intuitive test UI with comprehensive views allow you to attempt test items from across 26+ different question types."
    
    static let title3 = "Autosaved responses"
    static let subTitle3 =  "Our platform autosaves your responses regularly and frequently so that you can resume your assessment in the fastest possible way."
    
    static let title4 = "Proctor-enabled Assessments"
    static let subTitle4 = "Some of the assessments may be monitored thorough proctors in real-time to avoid use of any fraudulent means."
    
    static let title5 = " Assessment in Lockdown mode"
    static let subTitle5 = " During an assessment, your device will enter a lockdown mode to provide you with a disturbance free environment."
    
    /// API Error Messages
    static let ErrorMessage = "Something went wrong"
    static let SessionExpireMessage = "Your session is expired, please login again. Thank you."
    static let BadRequesErrorMessage = "Incorrect request by user"
    static let NetworkErrorMessage = "Please check you internet connection"
    static let ServerErrorMessage = "Server is not available try later"
    static let AuthorizeErrorMessage = "You are not authorized, please login again"
    static let ParsingErrorMessage = "Request response is incorrect parse issue"

    
    // MARK: - Sidemenu Constants
    static let helpUrl = "https://mettl.com/contact-us/?utm_medium=ppc&utm_source=adwords&utm_campaign=6496978781&ads_cmpid=6496978781&ads_adid=80644414969&ads_targetid=kwd-372040230718&ads_network=g&ads_creative=381927335886&ads_kw_term=mettl&gclid=Cj0KCQjw3v6SBhCsARIsACyrRAkLCPzeOv_1Chq2G1s1dBVEF1eRAY4l9HJTICqRh3cWhEjtu4eN0rUaAmYyEALw_wcB"
    static let aboutUsUrl = "https://mettl.com/?utm_medium=ppc&utm_source=adwords&utm_campaign=6496978781&ads_cmpid=6496978781&ads_adid=80644414969&ads_targetid=kwd-372040230718&ads_network=g&ads_creative=381927335886&ads_kw_term=mettl&gclid=Cj0KCQjw3v6SBhCsARIsACyrRAkLCPzeOv_1Chq2G1s1dBVEF1eRAY4l9HJTICqRh3cWhEjtu4eN0rUaAmYyEALw_wcB"
}
