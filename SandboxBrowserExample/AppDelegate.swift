//
//  AppDelegate.swift
//  AirSandboxExample
//
//  Created by Joe on 2017/8/25.
//  Copyright © 2017年 Joe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let testUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let plistPath = testUrl?.path.appending("/example.plist")
        let pngPath = testUrl?.path.appending("/example.png")
        let dbPath = testUrl?.path.appending("/example.sqlite3")
        let logPath = testUrl?.path.appending("/example.log")
        let logoPath = testUrl?.path.appending("/iOSLogo.jpg")
        do {
            try "Sandbox Browser".write(toFile: plistPath!, atomically: true, encoding: .utf8)
            try "Sandbox Browser".write(toFile: pngPath!, atomically: true, encoding: .utf8)
            try "Sandbox Browser".write(toFile: dbPath!, atomically: true, encoding: .utf8)
            try "Sandbox Browser".write(toFile: logPath!, atomically: true, encoding: .utf8)
            
            if let docPath = logoPath,
                !FileManager.default.fileExists(atPath: docPath),
                let sourceUrl = Bundle.main.url(forResource: "iOS_logo", withExtension: "jpg") {
                let docUrl = URL(fileURLWithPath: docPath)
                let data = try Data(contentsOf: sourceUrl)
                try data.write(to: docUrl)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            self.enableSwipe()
        })
        
        return true
    }
    
    
    public func enableSwipe() {
        let pan = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDetected))
        pan.numberOfTouchesRequired = 1
        pan.direction = .left
        UIApplication.shared.keyWindow?.addGestureRecognizer(pan)
    }
    
    @objc func onSwipeDetected(){
        
        let sandboxBrowser = SandboxBrowser()
//        sandboxBrowser.didSelectFile = { file, vc in
//            print(file.name, file.type)
//        }
        window?.rootViewController?.present(sandboxBrowser, animated: true, completion: nil)
    }
}

