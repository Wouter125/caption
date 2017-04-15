//
//  CustomSearchField.swift
//  caption
//
//  Created by Wouter van de Kamp on 08/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class CustomSearchField: NSTextField {
//    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//        wantsLayer = true
//        let textFieldLayer = CALayer()
//        layer?.addSublayer(textFieldLayer)
//        backgroundColor = NSColor.white
//        textFieldLayer.backgroundColor = CGColor.white
//        textFieldLayer.borderColor = CGColor.white
//        textFieldLayer.borderWidth = 0
//    }
}

class CustomSearchFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let minimumHeight = self.cellSize(forBounds: rect).height
        let newRect = NSRect(x: rect.origin.x + 25, y: (rect.origin.y + (rect.height - minimumHeight) / 2) - 2, width: rect.size.width - 25, height: minimumHeight)
        
        return super.drawingRect(forBounds: newRect)
    }
}
