//
//  CustomColorView.swift
//  caption
//
//  Created by Wouter van de Kamp on 08/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class CustomColorView : NSView {
    override func draw(_ dirtyRect: NSRect) {
        let grayColor = NSColor(deviceRed: 0.909, green: 0.909, blue: 0.909, alpha: 1.0)
        grayColor.setFill()
        NSRectFill(dirtyRect)
        super.draw(dirtyRect)
    }
}
