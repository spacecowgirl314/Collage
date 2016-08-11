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
    var scrollView = NSScrollView()
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
                for (index, item) in self.items!.enumerated() {
                    let image = NSImage(contentsOf: item)
                    self.images[item] = image
                    //                    DispatchQueue.main.async {
                    //                        collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                    //                    }
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
//        guard let item = CollectionViewItem else { return item }
        if let url = self.items?[indexPath.item] {
            if let imageView = item.ikImageView {
                imageView.setImageWith(url)
            }
            // if the image doesn't exist add it to the cache
//            if let image = self.images[url] {
//                if var imageView = item.ikImageView {
//                    imageView.animator().alphaValue = 0.0
//                    NSBitmapImageRep(data: image.tiffRepresentation!)
//                    imageView.setImage(CGImage(copy: image), imageProperties: nil)
//                    NSAnimationContext.beginGrouping()
//                    NSAnimationContext.current().duration = 3
//                    imageView.animator().alphaValue = 1.0
//                    NSAnimationContext.endGrouping()
//                }
//            } else { // image wasn't found, add it to the cache
//                if let imageView = item.ikImageView {
//                    imageView.setImageWith(url)
//                }
//                DispatchQueue.global().async {
//                    Swift.print("butts")
                    
//                    let image = NSImage(contentsOf: url)
//                    self.images[url] = image
//                    if let imageView = item.imageView {
                        //                        imageView.image = image
//                    }
                    // this is a lazy hack to get it to reload with the size from the cached image
//                    DispatchQueue.main.async {
//                        self.collectionView?.reloadItems(at: [indexPath])
//                    }
//                }
//            }
        }
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> NSSize {
        if let url = self.items?[indexPath.item] {
            // if the image doesn't exist add it to the cache
            if let image = self.images[url] {
                return NSSize(width: image.size.width, height: image.size.height)
            } else { // image wasn't found return standard
                return NSSize(width: 300, height: 300)
            }
        } else {
            return NSSize(width: 0, height: 0)
        }
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    //    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
    //        let view = NSView(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)))
    //        let image = NSImage(named: NSImageNameComputer)
    //        let imageView = NSImageView(frame: view.bounds)
    //        imageView.image = image
    //        view.addSubview(imageView)
    //        return view
    //    }
}
