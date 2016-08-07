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
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1/30.0
        self.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        self.autoresizesSubviews = true
//        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func startAnimation() {
        super.startAnimation()
        collageView = CollageView.init(frame: bounds)
        if let collageView = collageView {
            collageView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            collageView.autoresizesSubviews = true
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
            collageView.setNeedsDisplay(collageView.bounds)
        }
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func configureSheet() -> NSWindow? {
        return nil
    }
}
