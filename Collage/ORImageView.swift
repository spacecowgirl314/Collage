//
//  ORImageView.swift
//  Collage
//
//  Created by Chloe Stars on 8/13/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import CoreGraphics

var images = [URL:CGImage]()
var animations = [URL:CAKeyframeAnimation]()

extension NSImage {
    func CGImage() -> CGImage? {
        guard let data = self.tiffRepresentation else { return nil }
        guard let source = CGImageSourceCreateWithData(data, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
}

class ORImageView: IKImageView {
    
    override func awakeFromNib() {
        // create an overlay for the image (which is used to play animated gifs)
        // EDIT: well, don't do that here, due to some initialization orders
        //       problem, it might gives an error and not create the overlay
        //       I leave that line here for the records ^^
        //[self setOverlay:[CALayer layer] forType:IKOverlayTypeImage];
        
        // NOTE: calling this before anything else seems to fix a lot of
        //       problems ... maybe it's initializing a few things internally
        //       on the first call ...
        super.setImageWith(nil)
    }
    
    func isGIF(path: URL) -> Bool {
        let pathExtension = path.pathExtension.lowercased()
        return pathExtension == "gif"
    }
    
    override func setImageWith(_ url: URL!) {
        self.alphaValue = 0.0
        if self.overlay(forType: IKOverlayTypeImage) != nil {
//            self
        }
        
        self.overlay(forType: IKOverlayTypeImage).removeAllAnimations()
        
        if isGIF(path: url) {
            DispatchQueue.global().async {
                if animations[url] {
                    self.overlay(forType: IKOverlayTypeImage).add(animations[url], forKey: "contents")
                    self.alphaValue = 1.0
                }
            }
        }
    }
}
