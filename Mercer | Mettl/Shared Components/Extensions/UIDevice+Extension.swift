//
//  UIDevice+Extension.swift
//  Mercer | Mettl
//
//  Created by mohd-ali-khan on 01/12/22.
//

import Foundation
import UIKit
import AVFoundation

extension UIDevice {
    static func toggleFlashLight() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: 1.0)
            device.torchMode = device.isTorchActive ? .off : .on
            device.unlockForConfiguration()
        } catch {
            assert(false, "error: device flash light, \(error)")
        }
    }
    
}
