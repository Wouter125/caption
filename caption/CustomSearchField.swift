//
//  customSearchField.swift
//  caption
//
//  Created by Wouter van de Kamp on 13/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class CustomSearchField: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let minimumHeight = self.cellSize(forBounds: rect).height
        let newRect = NSRect(x: rect.origin.x + 25, y: (rect.origin.y + (rect.height - minimumHeight) / 2) - 4, width: rect.size.width - 25, height: minimumHeight)
        
        return super.drawingRect(forBounds: newRect)
    }
    
}
