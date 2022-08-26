//
//  WebAction.swift
//  Dev_Mercer_Mettl
//
//  Created by mohd-ali-khan on 23/08/22.
//

import Foundation
// MARK: - JS to swift Action name
public enum  MercerMettlWebActionName: String {
    case LOCKED = "locked"
    case DENYBYUSER = "unlocked"
    case UNLOCKEDBYUSER = "unlockedByUser"
    case TESTRESUME = "testResume"
    case SCREENPERMISSIONSUCCESS = "screenPermissionSuccess"
    case SCREENPERMISSIONERROR = "screenPermissionError"
    case SCREENIMAGE = "screenImage"
    case SCREENIMAGEERROR = "screenImageError"
    case SCREENPERMISSIONREVOKE = "screenPermissionRevoke"
    case MULTIPLESCREENDETECTED = "multipleScreenDetected"
}
// MARK: - JS to swift Action name
public enum MercerMettlWebCallBackActionName: String {
    case SHOWTOAST = "showToast"
    case ENABLELOCKMODE = "enableLockMode"
    case DISABLELOCKMODE = "disableLockMode"
    case SHOWUNLOCKDIALOG = "showUnlockDialog"
    case ENABLESCREENCAPTURE = "enableScreenCapture"
    case STARTSCREENCAPTURE = "startScreenCapture"
    case STOPSCREENCAPTURE = "stopScreenCapture"
    case CLOSEAPP = "closeApp"
    case UPDATEWEBVIEW = "updateWebView"
    case OPENLINK = "openLink"
    case DEFAULT = "default"
}
