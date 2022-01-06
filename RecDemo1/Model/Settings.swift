//
//  Settings.swift
//  RecDemo1
//
//  Created by Kenji on 2021/12/29.
//

import Foundation

class Settings {
    let UD = UserDefaults.standard
    let keyPrefix = "RecDemo1.Settings"
    
    var targetURL: URL {
        get {
            return UD.url(forKey: keyPrefix+".targetURL") ?? FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("RecDemo1")
        }
        set {
            UD.set(newValue, forKey: keyPrefix+".targetURL")
        }
    }
    var fps: Int {
        get {
            let fps = UD.integer(forKey: keyPrefix+".fps")
            return fps == 0 ? 30 : fps
        }
        set {
            UD.set(newValue, forKey: keyPrefix+".fps")
        }
    }
    // 1 - low, 2 - medium, 3 - high
    var quality: Int {
        get {
            let quality = UD.integer(forKey: keyPrefix+".quality")
            return quality == 0 ? 3 : quality
        }
        set {
            UD.set(newValue, forKey: keyPrefix+".quality")
        }
    }
}
