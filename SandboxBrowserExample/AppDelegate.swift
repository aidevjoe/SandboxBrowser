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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let testUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let plistpath = testUrl?.path.appending("/example.plist")
        let pngpath = testUrl?.path.appending("/example.png")
        let dbpath = testUrl?.path.appending("/example.sqlite3")
        let logpath = testUrl?.path.appending("/example.log")
        do {
            try "Sandbox Browser".write(toFile: plistpath!, atomically: true, encoding: .utf8)
            try "Sandbox Browser".write(toFile: pngpath!, atomically: true, encoding: .utf8)
            try "Sandbox Browser".write(toFile: dbpath!, atomically: true, encoding: .utf8)
            try "Sandbox Browser".write(toFile: logpath!, atomically: true, encoding: .utf8)
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
    
    func onSwipeDetected(){
        
        let sandboxBrowser = SandboxBrowser()
        sandboxBrowser.didSelectFile = { file, vc in
            print(file.name, file.type)
        }
        window?.rootViewController?.present(sandboxBrowser, animated: true, completion: nil)
    }
}

