//
//  CollectionViewItem.swift
//  Collage
//
//  Created by Chloe Stars on 8/7/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import Cocoa
import Quartz

class CollectionViewItem: NSCollectionViewItem {
    @IBOutlet var ikImageView: ORImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        self.view.autoresizesSubviews = true
        if let imageView = ikImageView {
            imageView.backgroundColor = NSColor.clear
            imageView.canDrawSubviewsIntoLayer = true
            imageView.wantsLayer = true
        }
    }
}
