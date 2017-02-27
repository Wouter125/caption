//
//  CustomTableViewRow.swift
//  caption
//
//  Created by Wouter van de Kamp on 18/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class CustomTableViewRow: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .none {
            let selectionRect = NSInsetRect(self.bounds, 0, 0)
            NSColor(calibratedRed: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0).setStroke()
            NSColor(calibratedRed: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0).setFill()
            let selectionPath = NSBezierPath.init(roundedRect: selectionRect, xRadius: 0, yRadius: 0)
            selectionPath.fill()
            selectionPath.stroke()
        }
    }
}
