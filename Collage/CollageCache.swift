//
//  CollageCache.swift
//  Collage
//
//  Created by Chloe Stars on 8/14/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import Quartz

class CollageCache {
    static var sharedCache = CollageCache()
    var animationCache = [String:CAKeyframeAnimation]()
    var imageCache = [String:CGImage]()
    var sizeCache = [String:NSSize]()
}
