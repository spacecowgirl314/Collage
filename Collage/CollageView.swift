//
//  CollageView.swift
//  Collage
//
//  Created by Chloe Stars on 8/7/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import Cocoa

class CollageView: NSView, ImageCollectionDelegate, NSCollectionViewDataSource {
    private var collectionView: NSCollectionView?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let collection = ImageCollection(url: URL(string:"http://cybercatgurrl.tumblr.com/rss")!)
        collection.delegate = self
        collection.parse()
        collectionView = NSCollectionView.init(frame: bounds)
        collectionView?.dataSource = self
        if let collectionView = collectionView {
            collectionView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
            addSubview(collectionView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func didFinishLoading(urls: [URL]) {
        //
    }
    
    func didFailLoading() {
        //
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return NSCollectionViewItem()
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        return NSView()
    }
}
