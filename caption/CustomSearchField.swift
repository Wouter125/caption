//
//  CustomSearchField.swift
//  caption
//
//  Created by Wouter van de Kamp on 08/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class CustomSearchField: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        self.wantsLayer = true
        let textFieldLayer = CALayer()
        self.layer = textFieldLayer
        self.backgroundColor = NSColor.white
        self.layer?.backgroundColor = CGColor.white
        self.layer?.borderColor = CGColor.white
        self.layer?.borderWidth = 0
    }
}

class CustomSearchFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let minimumHeight = self.cellSize(forBounds: rect).height
        let newRect = NSRect(x: rect.origin.x + 25, y: (rect.origin.y + (rect.height - minimumHeight) / 2) - 2, width: rect.size.width - 25, height: minimumHeight)
        
        return super.drawingRect(forBounds: newRect)
    }
}
