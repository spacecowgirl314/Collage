//
//  AppDelegate.swift
//  Demo
//
//  Created by Chloe Stars on 8/6/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    
    let view: ScreenSaverView! = {
        let view = MainView(frame: CGRect.zero, isPreview: false)
        return view
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        // Add the clock view to the window
        view.frame = (window.contentView?.bounds)!
        window.contentView?.addSubview(view)
        
        // Start animating the clock
        view.startAnimation()
        Timer.scheduledTimer(timeInterval: view.animationTimeInterval, target: view, selector: #selector(ScreenSaverView.animateOneFrame), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

