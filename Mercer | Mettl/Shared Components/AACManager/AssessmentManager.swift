//
//  AssessmentManager.swift
//  Dev_Mercer_Mettl
//
//  Created by mohd-ali-khan on 20/07/22.
//

import Foundation
import AutomaticAssessmentConfiguration

class AssessmentManager: NSObject , AEAssessmentSessionDelegate{
    
    static let shared = AssessmentManager()
    
    let config = AEAssessmentConfiguration()
    var session : AEAssessmentSession?
    
    func setUpAssessment(){
        session = AEAssessmentSession(configuration: config)
        session?.delegate = self
    }
    
    func beginAssessmnetMode() {
        session?.begin()
    }
    
    func endAssessmentMode() {
        session?.end()
    }
    
    func assessmentSessionDidBegin(_ session: AEAssessmentSession) {
        //session.begin()
        print(session.isActive)
        print("Session Did Begin")
    }
    
    func assessmentSession(_ session: AEAssessmentSession, wasInterruptedWithError error: Error) {
        //session.end()
        print("Session was interrupted with error",error.localizedDescription)
    }
    
    func assessmentSession(_ session: AEAssessmentSession, failedToBeginWithError error: Error) {
        print("Failed to begin error",error.localizedDescription)
        //  session.end()
    }
    
    func assessmentSessionDidEnd(_ session: AEAssessmentSession) {
        print("Assessment Session Did end")
    }
    
}


