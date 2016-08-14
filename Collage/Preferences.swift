//
//  Preferences.swift
//  Collage
//
//  Created by Chloe Stars on 8/11/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import ScreenSaver

let BundleIdentifier = "me.chloestars.Collage"
let URLDefaultsKey = "CSURL"
let ScaleDefaultsKey = "CSScale"
let PreferencesChangedNotificationName = NSNotification.Name("CSPreferencesChangedNotification")

/// This class contains various properties that map directly to UserDefaults
class Preferences {
    /// Contains a UserDefaults object for the screensaver.
    private let preferences: UserDefaults = ScreenSaverDefaults(forModuleWithName: BundleIdentifier)! as ScreenSaverDefaults
    
    /// A property that maps directly to UserDefaults for setting the scale of the images in the collage.
    var scale: Double {
        set {
            // make sure the values are valid
            if newValue >= 0.0 && newValue <= 1.0 {
                preferences.set(newValue, forKey: ScaleDefaultsKey)
                self.save()
            }
        }
        get {
            return preferences.double(forKey: ScaleDefaultsKey)
        }
    }
    
    /// A property that maps directly to UserDefaults for setting the URLs used with the screensaver.
    var urls: [String]  {
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            preferences.set(data, forKey: URLDefaultsKey)
            self.save()
        }
        get {
            if let data = preferences.data(forKey: URLDefaultsKey) {
                if let urls = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String] {
                    return urls
                }
                else {
                    return [String]()
                }
            } else {
                return [String]()
            }
        }
    }
    
    /// Synchronize with the disk and post a PreferencesChangedNotificationName notification.
    func save() {
        preferences.synchronize()
        NotificationCenter.default.post(name: PreferencesChangedNotificationName, object: nil)
    }
    
    /// Initalizes a new Preferences object.
    ///
    /// - returns: An initalized Preferences object.
    init() {
        let defaultURLs = ["http://acme.com/jef/apod/rss.xml"]
        let data = NSKeyedArchiver.archivedData(withRootObject: defaultURLs)
        preferences.register(defaults: [
            ScaleDefaultsKey: 0.2,
            URLDefaultsKey: data
            ])
    }
}
