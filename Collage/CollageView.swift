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
    private var collectionView: NSCollectionView?
    var items: [URL]?
    
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
        let collection = ImageCollection(url: URL(string:"http://cybercatgurrl.tumblr.com/rss")!)
        collection.delegate = self
        collection.parse()
        collectionView = NSCollectionView.init(frame: bounds)
        if let collectionView = collectionView {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            collectionView.autoresizesSubviews = true
            collectionView.collectionViewLayout = NSCollectionViewFlowLayout()
            self.addSubview(collectionView)
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
            collectionView.reloadData()
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
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else { return item }
        let image = NSImage(named: NSImageNameComputer)
        item.imageView?.image = image
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> NSSize {
        return NSSize(width: 300, height: 300)
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
