//
//  ViewController.swift
//  RecDemo1
//
//  Created by Kenji on 2021/12/29.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var folderPicker: NSPopUpButton!
    @IBOutlet weak var folderLabel: NSTextField!
    @IBOutlet weak var fpsPicker: NSPopUpButton!
    @IBOutlet weak var qualityPicker: NSPopUpButton!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var maskView: NSView!
    @IBOutlet weak var countdownLabel: NSTextField!
    
    var settings = Settings()
    var capture = Capture()
    
    var countdownSeconds = 3
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updatePickers()
        folderButtonClicked(self)
        
        maskView.wantsLayer = true
        maskView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func updatePickers() {
        if settings.targetURL == targetURL(with: .desktopDirectory) {
            folderPicker.selectItem(at: 0)
        } else if settings.targetURL == targetURL(with: .documentDirectory) {
            folderPicker.selectItem(at: 1)
        }
        fpsPicker.selectItem(withTag: settings.fps)
        qualityPicker.selectItem(withTag: settings.quality)
    }
    
    func targetURL(with type: FileManager.SearchPathDirectory) -> URL {
        var url = FileManager.default.urls(for: type, in: .userDomainMask)[0]
        url = url.appendingPathComponent("RecDemo1")
        return url
    }
    
    func startCapture() {
        startButton.isEnabled = false
        
        capture.isCapturing = true
        capture.start()
    }
    
    @objc func countdown() {
        countdownSeconds -= 1
        self.countdownLabel.stringValue = "\(countdownSeconds)"
        
        if countdownSeconds == 0 {
            timer?.invalidate()
            self.countdownLabel.stringValue = "Recording……"
            
            self.startCapture()
        }
    }
    
}

extension ViewController {
    @IBAction func folderButtonClicked(_ sender: Any) {
        if folderPicker.indexOfSelectedItem == 0 {
            settings.targetURL = targetURL(with: .desktopDirectory)
            folderLabel.stringValue = targetURL(with: .desktopDirectory).debugDescription
        } else if folderPicker.indexOfSelectedItem == 1 {
            settings.targetURL = targetURL(with: .documentDirectory)
            folderLabel.stringValue = targetURL(with: .documentDirectory).debugDescription
        }
    }
    
    @IBAction func fpsButtonClicked(_ sender: NSPopUpButton) {
        settings.fps = sender.selectedItem?.tag ?? 30
    }
    
    @IBAction func qualityButtonClicked(_ sender: NSPopUpButton) {
        settings.quality = sender.selectedItem?.tag ?? 2
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        startButton.isEnabled = false
        maskView.isHidden = false
        countdownSeconds = 3
        countdownLabel.stringValue = "\(countdownSeconds)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        if let timer = timer {
            timer.invalidate()
            maskView.isHidden = true
            startButton.isEnabled = true
        }
        
        startButton.isEnabled = true
        
        capture.isCapturing = false
        capture.stop()
        
        maskView.isHidden = true
    }
}

