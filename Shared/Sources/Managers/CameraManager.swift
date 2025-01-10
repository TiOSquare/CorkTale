//
//  CameraManager.swift
//  CorkTale
//
//  Created by 홍기웅 on 12/11/24.
//

import AVFoundation
import CoreImage
import Foundation

public class CameraManager: NSObject {
    private let session = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var deviceOutput: AVCaptureVideoDataOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    private let logger = Log.make(with: .shared)
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    public lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { [weak self] continuation in
            self?.addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    public override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    private func checkAuthorization() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        var isAuthorized = status == .authorized
        
        if status == .notDetermined {
            isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
        }
        return isAuthorized
    }
    
    private func configureSession() async {
        
        guard await checkAuthorization(),
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera) else {
            
            logger.log(level: .error, "failed to configure session")
            return
        }
        
        sessionQueue.async {
            self.session.beginConfiguration()
            
            defer {
                self.session.commitConfiguration()
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            
            guard self.session.canAddInput(deviceInput) else {
                self.logger.log(level: .error, "Unable to add device input to capture session.")
                return
            }
            
            guard self.session.canAddOutput(videoOutput) else {
                self.logger.log(level: .error, "Unable to add video output to capture session.")
                return
            }
            
            self.session.addInput(deviceInput)
            self.session.addOutput(videoOutput)
        }
    }
    
    private func startSession() async {
        guard await checkAuthorization() else { return }
        sessionQueue.async {
            self.session.startRunning()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        
        guard let currentFrame = sampleBuffer.cgImage else {
            logger.log(level: .error, "Failed to get CGImage from sample buffer")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.addToPreviewStream?(currentFrame)
        }
    }
}


extension CMSampleBuffer {
    var cgImage: CGImage? {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(self) else { return nil }
        
        return CIImage(cvPixelBuffer: pixelBuffer).cgImage
    }
}

extension CIImage {
    var cgImage: CGImage? {
        let ciContext = CIContext(options: nil)
        return ciContext.createCGImage(self, from: self.extent)
    }
}
