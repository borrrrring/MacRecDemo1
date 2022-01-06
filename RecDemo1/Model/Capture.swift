//
//  Capture.swift
//  RecDemo1
//
//  Created by Kenji on 2021/12/29.
//

import Foundation
import AVFoundation
import AppKit

class Capture: NSObject {
    
    lazy var session: AVCaptureSession = {
        return $0
    }( AVCaptureSession() )
    
    lazy var input: AVCaptureScreenInput? = {
        var input = AVCaptureScreenInput(displayID: CGMainDisplayID())
        return input
    }()
    
    lazy var output:AVCaptureMovieFileOutput = {
        $0.movieFragmentInterval = CMTime(value: 2, timescale: 1)
        return $0
    }( AVCaptureMovieFileOutput() )
    
    var isCapturing: Bool = false
    
    var settings = Settings()
    
    override init() {
        super.init()
        
        setupInput()
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
    }
    
    func setupInput() {
        if let input = input {
            input.capturesCursor = true
            input.capturesMouseClicks = true
            input.minFrameDuration = CMTime(value: 1, timescale: Int32(settings.fps))
            var quality: AVCaptureSession.Preset
            switch settings.quality {
            case 1:
                quality = .low
            case 2:
                quality = .medium
            default:
                quality = .high
            }
            session.sessionPreset = quality
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
    }
    
    func start() {
        session.startRunning()
        
        let folder = settings.targetURL.appendingPathComponent("Videos/")
        let list = try? FileManager.default.contentsOfDirectory(atPath: folder.path).compactMap { $0.contains("RecDemo") && $0.hasSuffix(".mov") ? $0 : nil }
        let count = list == nil ? "" : "\(list!.count)"
        let url = settings.targetURL.appendingPathComponent("Videos/RecDemo\(count).mov")
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        output.startRecording(to: url, recordingDelegate: self)
    }
    
    func stop() {
        output.stopRecording()
    }
    
}

extension Capture: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        session.stopRunning()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print(#function)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didPauseRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print(#function)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didResumeRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print(#function)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, willFinishRecordingTo fileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(#function)
    }
}
