//
//  AppAdaptables.swift
//  Mercer | Mettl
//
//  Created by m@k on 18/04/22.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseIndentifier: String { get }
    static var nib: UINib? { get }
    func configure<T>(with content: T)
}

protocol ReusableReminder {
    static var reuseIndentifier: String { get }
    static var nib: UINib? { get }
    func configure<T>(with content: T, index: Int)
}

extension Reusable {
    static var reuseIndentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}

extension ReusableReminder {
    static var reuseIndentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}

protocol ControllerDismisser: AnyObject {
    func dismiss(controller:Scenes)
}

protocol PushNextController:AnyObject {
    func push(scene:Scenes)
}

@objc protocol PopPreviousController: AnyObject {
    @objc optional func popController()
}

protocol CoordinatorDimisser:AnyObject {
    func dismiss(coordinator:Coordinator<Scenes>)
}

protocol ScenePresenter {
    func present(scene:Scenes)
}

protocol RowSectionDisplayable {
    var title: String { get }
}

protocol RowJournalSectionDisplayable {
    var title: Date { get }
}

typealias Dismisser = ControllerDismisser & CoordinatorDimisser
typealias NextSceneDismisser = PushNextController & ControllerDismisser & PopPreviousController
typealias NextSceneDismisserPresenter = NextSceneDismisser & Dismisser

