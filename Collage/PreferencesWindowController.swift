//
//  PreferencesWindowController.swift
//  Collage
//
//  Created by Chloe Stars on 8/11/16.
//  Copyright © 2016 Chloe Stars. All rights reserved.
//

import Foundation
import Cocoa

class PreferencesWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var scaleSlider: NSSlider!
    private let preferences = Preferences()
    
    override var windowNibName: String! {
        return "Preferences"
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(editingEnded(notification:)), name: .NSControlTextDidEndEditing, object: nil)
        scaleSlider.doubleValue = preferences.scale*100
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func editingEnded(notification: Notification) {
        if let textField = notification.object as? NSTextField {
            // we are modifying the arrangedController directly because it does not update on it's own????
            preferences.urls[tableView.selectedRow] = textField.stringValue
            preferences.urls = preferences.urls
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return preferences.urls.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.make(withIdentifier: "url", owner: tableView.delegate)
        if let view = view as? NSTableCellView {
            if let textField = view.textField {
                textField.stringValue = preferences.urls[row]
            }
        }
        return view
    }
    
    @IBAction func scaleChanged(sender: NSSlider) {
        preferences.scale = sender.doubleValue/100
    }
    
    @IBAction func addFeed(sender: AnyObject) {
        preferences.urls.append("")
        // THIS IS THE MOST RIDICULOUS WAY TO FORCE THE PREFS TO SYNC. 🎉
        // we do this to trigger the setter on the property and cause a synchronization to disk
        preferences.urls = preferences.urls
        print("count: \(preferences.urls.count)")
        tableView.insertRows(at: IndexSet(integer: preferences.urls.count), withAnimation: .slideLeft)
    }
    
    @IBAction func removeFeed(sender: AnyObject) {
        preferences.urls.remove(at: tableView.selectedRow)
        // THIS IS THE MOST RIDICULOUS WAY TO FORCE THE PREFS TO SYNC. 🎉
        // we do this to trigger the setter on the property and cause a synchronization to disk
        preferences.urls = preferences.urls
        tableView.removeRows(at: IndexSet(integer: tableView.selectedRow), withAnimation: .slideRight)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.window?.sheetParent?.endSheet(self.window!)
    }
}
