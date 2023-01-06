//
//  ScannerViewController.swift
//  Mercer | Mettl
//
//  Created by mohd-ali-khan on 01/12/22.
//

import AVFoundation
import UIKit
import Lottie

protocol getQRResultDelegates {
    func fetchedQRCode(codeStr: String)
}
class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var viewCamera : UIView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnFlash : UIButton!
    @IBOutlet weak var lblAlignTheQR : UILabel!
    @IBOutlet weak var lblScanningWill : UILabel!
    @IBOutlet weak var animationView: AnimationView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: getQRResultDelegates? = nil
    weak var router: NextSceneDismisser?
    let viewModel = ScannerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionManager()
        configureFonts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @IBAction func torchAction(_ sender: UIButton){
        UIDevice.toggleFlashLight()
        if !btnFlash.isSelected {
            btnFlash.isSelected = true
        }
        else {
            btnFlash.isSelected = false
        }
    }
}

extension ScannerViewController {
    private func configureFonts() {
        self.lblAlignTheQR.font = UIFont.setFont(fontType: .medium, fontSize: .medium)
        self.lblScanningWill.font = UIFont.setFont(fontType: .regular, fontSize: .regular)
    }
}

extension ScannerViewController {
    private func captureSessionManager() {
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        let y = (self.view.frame.height / 2) - (self.viewCamera.frame.height / 2)
        let x = (self.view.frame.width / 2) - (self.viewCamera.frame.width / 2)
        let frame = CGRect.init(x: x + 25, y: y + 30, width: self.viewCamera.frame.size.width - 50, height: self.viewCamera.frame.size.width - 50)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.cornerRadius = 20
        previewLayer.borderColor = UIColor.setColor(colorType: .Scanerborder).cgColor
        previewLayer.borderWidth = 3.0
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = frame
        //view.layer.insertSublayer(previewLayer, at: 0)
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
        // Animation
        animationView.frame = frame
        view.addSubview(animationView)
        startAnimation()
        
    }
    private func startAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
    func failed() {
        customAlert(AppConstant.scanningNotSupported,
                    AppConstant.scanningAlertMessage,
                    AppConstant.retryBtnTitle)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
    }
    
    func found(code: String) {
        delegate?.fetchedQRCode(codeStr: code)
        if code.contains("https://tests.mettl.com") {
            if code.contains("https://tests.mettl.com/v2") {
                viewModel.ScannedWebUrl = code
                // dismiss(animated: true)
                self.router?.push(scene: .webview)
            }
            else {
                guard let url = URL(string: code) else { return }
                UIApplication.shared.open(url)
            }
            print(code)
        }
        else {
            captureSession.startRunning()
            customAlert(AppConstant.scanningNotSupported,
                        AppConstant.scanningAlertMessage,
                        AppConstant.retryBtnTitle)
        }
    }
    
    private func customAlert(_ title: String,_ message: String, _ btnTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
