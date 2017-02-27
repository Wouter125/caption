//
//  AppDelegate.swift
//  caption
//
//  Created by Wouter van de Kamp on 13/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared().activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

