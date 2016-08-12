//
//  CollageView.swift
//  Collage
//
//  Created by Chloe Stars on 8/7/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import Cocoa

class CollageView: NSView, ImageCollectionDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate {
    var collectionView: NSCollectionView?
    var scrollView = NoScrollView()
    var items: [URL]?
    var images = [URL:NSImage]()
    var collection: ImageCollection!
    
    override var frame: CGRect {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init?(frame: NSRect, isPreview: Bool) {
        self.init(frame: frame)
    }
    
    required override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        collection = ImageCollection(url: URL(string:"http://cybercatgurrl.tumblr.com/rss")!)
        collection.delegate = self
        collection.parse()
        collectionView = NSCollectionView.init(frame: bounds)
        if let collectionView = collectionView {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            collectionView.autoresizesSubviews = true
            let layout = NSCollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = EdgeInsets(top: layout.minimumLineSpacing, left: layout.minimumLineSpacing, bottom: layout.minimumLineSpacing, right: layout.minimumLineSpacing)
            collectionView.collectionViewLayout = layout
            scrollView.frame = bounds
            scrollView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            scrollView.autoresizesSubviews = true
            scrollView.hasVerticalScroller = true
            scrollView.hasHorizontalScroller = true
            scrollView.verticalScroller?.alphaValue = 0.0
            scrollView.horizontalScroller?.alphaValue = 0.0
            scrollView.borderType = .noBorder
            scrollView.documentView = collectionView
            self.addSubview(scrollView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // what is this private API thing that keeps being called????
    //    class func spansScreens() -> ObjCBool {
    //        return ObjCBool(false)
    //    }
    
    func didFinishLoading(urls: [URL]) {
        items = urls
        if let collectionView = collectionView {
            DispatchQueue.global().async {
                // TODO: this is redudant and a vestige of caching the images in this view. find another way
                for (index, item) in self.items!.enumerated() {
                    let image = NSImage(contentsOf: item)
                    self.images[item] = image
                }
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func didFailLoading() {
        // not sure what to do here yet
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = items {
            return items.count
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath) as! CollectionViewItem
        if let url = self.items?[indexPath.item] {
            if let imageView = item.ikImageView {
                imageView.setImageWith(url)
            }
        }
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> NSSize {
        if let url = self.items?[indexPath.item] {
            // get the cached image's size
            if let image = self.images[url] {
                return NSSize(width: image.size.width, height: image.size.height)
            } else { // image wasn't found return nothing
                return NSSize(width: 0, height: 0)
            }
        } else {
            return NSSize(width: 0, height: 0)
        }
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
}

class NoScrollView: NSScrollView {
    override func scrollWheel(with event: NSEvent) {}
}
