//
//  DragNDropController.swift
//  caption
//
//  Created by Wouter van de Kamp on 15/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class DragDropView: NSView {
    
    var filePath: String?
    let expectedExt = ["jpg", "avi"] //file extensions allowed for Drag&Drop
    var placeholderText: NSTextField?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        placeholderText = self.subviews[0] as? NSTextField
        self.alphaValue = 0.5
        
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // dash customization parameters
        let lineWidth: CGFloat = 1
        let dashHeight: CGFloat = 3
        let dashLength: CGFloat = 5
        let dashColor: NSColor = .white
        
        // setup the context
        let currentContext = NSGraphicsContext.current()!.cgContext
        currentContext.setLineWidth(lineWidth)
        currentContext.setLineDash(phase: 0, lengths: [dashLength])
        currentContext.setStrokeColor(dashColor.cgColor)
        
        // draw the dashed path
        currentContext.addRect(bounds.insetBy(dx: dashHeight, dy: dashHeight))
        currentContext.strokePath()
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.alphaValue = 1.0
            placeholderText?.stringValue = "Drop Files"
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.alphaValue = 0.5
        placeholderText?.stringValue = "Drop an episode or season"
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.alphaValue = 0.5
        placeholderText?.stringValue = "Drop an episode or season"
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!
        self.filePath = path
        let videoHash = OpenSubtitlesHash.hashFor(filePath!)
        debugPrint("File hash: \(videoHash.fileHash)\nFile size: \(videoHash.fileSize)")
        
        return true
    }
}
