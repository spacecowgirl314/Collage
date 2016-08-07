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
        self.wantsLayer = true
        collageView = CollageView.init(frame: bounds)
        if let collageView = collageView {
            collageView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            addSubview(collageView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
    }
    
    override func animateOneFrame() {
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
