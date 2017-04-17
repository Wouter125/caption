//
//  CustomWindowController.swift
//  caption
//
//  Created by Wouter van de Kamp on 08/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class CustomWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window {
            window.styleMask.insert(NSWindowStyleMask.unifiedTitleAndToolbar)
            window.styleMask.insert(NSWindowStyleMask.fullSizeContentView)
            window.styleMask.insert(NSWindowStyleMask.titled)
            
            window.toolbar?.isVisible = false
            window.titleVisibility = .visible
            window.titlebarAppearsTransparent = true
            
            window.backgroundColor = NSColor.white
        }
    }
    
    @IBAction func didSelectSearch(_ sender: NSButton) {
        let controller = self.contentViewController as! CaptionViewController
        controller.makeFirstResponder()
    }
}
