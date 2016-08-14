//
//  MainView.swift
//  Collage
//
//  Created by Chloe Stars on 8/4/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import ScreenSaver

class MainView : ScreenSaverView {
    private var collageView: CollageView?
    private var preferencesWindowController: PreferencesWindowController!
    
//    private let preferencesWindowController: PreferencesWindowController = {
//        let controller = PreferencesWindowController()
////        controller.loadWindow()
//        return controller
//    }()
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1/30.0
        self.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        self.autoresizesSubviews = true
        self.preferencesWindowController = PreferencesWindowController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.animationTimeInterval = 1/30.0
        self.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        self.autoresizesSubviews = true
        self.preferencesWindowController = PreferencesWindowController()
    }
    
    override func startAnimation() {
        super.startAnimation()
        collageView = CollageView.init(frame: bounds)
        if let collageView = collageView {
            collageView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            collageView.autoresizesSubviews = true
            collageView.layer?.backgroundColor = NSColor.white.cgColor
            addSubview(collageView)
        }
    }
    
    override func stopAnimation() {
        super.stopAnimation()
        if let collageView = collageView {
            collageView.removeFromSuperview()
        }
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        if let collageView = collageView {
            var point = collageView.scrollView.contentView.bounds.origin
//            Swift.print("\(point) \(test)")
            if point.x >= (collageView.scrollView.documentView?.bounds.size.width)!-collageView.bounds.size.width {
                point = NSPoint.zero
            } else {
                point = NSPoint(x: point.x+3, y: point.y)
            }
            
            collageView.collectionView?.scroll(point)
            collageView.scrollView.reflectScrolledClipView(collageView.scrollView.contentView)
            collageView.setNeedsDisplay(collageView.bounds)
        }
    }
    
    override func hasConfigureSheet() -> Bool {
        return true
    }
    
    override func configureSheet() -> NSWindow? {
        return preferencesWindowController.window
    }
}
