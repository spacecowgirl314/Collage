//
//  ImageCollection.swift
//  Collage
//
//  Created by Chloe Stars on 8/6/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation

/// The ImageCollectionViewDelegate protocol defines methods for managing the response from the parser in an instance of ImageCollection.
protocol ImageCollectionDelegate: class {
    /// This method is called from an instance of ImageCollection when it has finished successfully parsing the image URLs.
    ///
    /// - parameter urls: An array of the resulting URLs from the source feed URL.
    func didFinishLoading(urls: [URL])
    /// This method is called from an instance of ImageCollection when it has failed to successfully parse the image URLs.
    func didFailLoading()
}

/// This class will parse an RSS feed and return a list of URLs for it's images.
class ImageCollection {
    /// The image collection's delegate object.
    /// 
    /// Use this to process the image URLs retrieved from the feed source and to deal with parsing failure.
    /// The object you assign to this property must conform to the ImageCollectionDelegate protocol.
    weak var delegate: ImageCollectionDelegate?
    /// This variable is the URL of the feed that's going to be parsed.
    private var feedURL: URL!
    
    /// Initialize with a URL.
    ///
    /// - parameter url: The URL of the feed.
    ///
    /// - returns: An initialized ImageCollection object.
    init(url: URL) {
        self.feedURL = url
    }
    
    /// This will parse the feed for image URLs from the provided URL during intialization.
    func parse() {
        DispatchQueue.global().async {
            do {
                var xmlString = String()
                do {
                    xmlString = try String(contentsOf: self.feedURL, encoding: .utf8)
                }
                catch {
                    self.delegate?.didFailLoading()
                }
                
                do {
                    let regex = try NSRegularExpression(pattern: "src\\s*=\\s*\"(.+?)\"", options: .caseInsensitive)
                    let matches = regex.matches(in: xmlString, options: [], range: NSMakeRange(0, xmlString.characters.count))
                    self.delegate?.didFinishLoading(urls:
                        matches.flatMap { URL(string:(xmlString as NSString).substring(with: $0.rangeAt(1))) })
                } catch {
                    self.delegate?.didFailLoading()
                }
            }
        }
    }
}
