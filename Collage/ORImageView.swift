//
//  ORImageView.swift
//  Collage
//
//  Created by Chloe Stars on 8/13/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import Cocoa
import Quartz

var images = [URL:CGImage]()
var animations = [URL:CAKeyframeAnimation]()

extension NSImage {
    func cgImage() -> CGImage? {
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
        return true
        let pathExtension = path.pathExtension.lowercased()
        return pathExtension == "gif"
    }
    
    func setImageWith(_ url: URL!, layout: NSCollectionViewLayout!) {
        self.alphaValue = 0.0
        if self.overlay(forType: IKOverlayTypeImage) == nil {
            self.setOverlay(CALayer(), forType: IKOverlayTypeImage)
        }
        
        self.overlay(forType: IKOverlayTypeImage).removeAllAnimations()
        
        if isGIF(path: url) {
            DispatchQueue.global().async {
                // capture layout here and prevent it from being released
                let layout = layout
                
                if let animation = CollageCache.sharedCache.animationCache[url.absoluteString] {
                    DispatchQueue.main.async {
                        self.overlay(forType: IKOverlayTypeImage).add(animation, forKey: "contents")
                        self.alphaValue = 1.0
                    }
                }
                else {
                    if let image = NSImage(contentsOf: url) {
                        CollageCache.sharedCache.sizeCache[url.absoluteString] = image.size
                        layout?.invalidateLayout()
                        // get the image representations, and iterate through them
                        let reps = image.representations
                        for case let rep as NSBitmapImageRep in reps {
                            // get the number of frames. If it's 0, it's not an animated gif, do nothing
                            guard let numberOfFrames = rep.value(forProperty: NSImageFrameCount) as? Int else { break }
                            if numberOfFrames == 0 { break }
                            
                            // create a value array which whill contain the frames of the animation
                            var values = [CGImage]()
                            
                            // loop through the animation frames (animationDuration is the duration of the whole animation)
                            var animationDuration = 0.0
                            for i in 0..<numberOfFrames {
                                // set the current frame
                                rep.setProperty(NSImageCurrentFrame, withValue: i)
                                
                                // this part is optional. For some reasons, the NSImage class often loads a GIF with
                                // frame times of 0, so the GIF plays extremely fast. So, we check the frame duration, and if it's
                                // less than a threshold value, we set it to a default value of 1/20 second.
                                if rep.value(forProperty: NSImageCurrentFrameDuration)!.doubleValue < 0.000001 {
                                    rep.setProperty(NSImageCurrentFrameDuration, withValue: 1.0 / 20.0)
                                }
                                
                                // add the CGImage to this frame to the value array
                                values.append(rep.cgImage!)
                                
                                // update the duration of the animation
                                animationDuration += rep.value(forProperty: NSImageCurrentFrameDuration)!.doubleValue
                            }
                            
                            // create and setup the animation (this is pretty straightforward)
                            let animation = CAKeyframeAnimation(keyPath: "contents")
                            animation.values = values
                            animation.calculationMode = "discrete"
                            animation.duration = animationDuration
                            animation.repeatCount = Float.infinity
                            
                            // add the animation to the layer
                            DispatchQueue.main.async {
                                layout?.invalidateLayout()
                                self.overlay(forType: IKOverlayTypeImage).add(animation, forKey: "contents")
                                CollageCache.sharedCache.animationCache[url.absoluteString] = animation
                                self.alphaValue = 1.0
                            }
                            
                            // stops at the first valid representation
                            break
                        }
                    }
                }
            }
        }
        
        // calls the super setImageWithURL method to handle standard images
        DispatchQueue.global().async {
            // capture layout here and prevent it from being released
            let layout = layout
            
            if let image = CollageCache.sharedCache.imageCache[url.absoluteString] {
                DispatchQueue.main.async {
                    super.setImage(image, imageProperties: nil)
                    self.alphaValue = 1.0
                }
            }
            else {
                if let image = NSImage(contentsOf: url) {
                    CollageCache.sharedCache.sizeCache[url.absoluteString] = image.size
                    let cgImage = image.cgImage()
                    CollageCache.sharedCache.imageCache[url.absoluteString] = cgImage
                    DispatchQueue.main.async {
                        layout?.invalidateLayout()
                        super.setImage(cgImage, imageProperties: nil)
                        self.alphaValue = 1.0
                    }
                }
            }
        }
    }
}
