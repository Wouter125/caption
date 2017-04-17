//
//  DragNDropController.swift
//  caption
//
//  Created by Wouter van de Kamp on 15/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

protocol DragDropDelegate {
    func droppingDidComplete(path: String?)
    func draggingDidEnter()
    func draggingDidExit()
    func draggingDidEnd()
}

class DragDropView: NSView {
    
    var filePath: String?
    let expectedExt = ["webm", "mkv", "flv", "vob", "ogv", "ogg", "drc", "avi", "mov", "qt", "wmv", "yuv", "asf", "amv", "mp4", "m4p", "m4v", "mpg", "mp2", "mpeg", "mpe", "mpv", "m2v", "m4v", "3gp", "f4v"] //file extensions allowed for Drag&Drop
    var placeholderText: NSTextField?
    var delegate:DragDropDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let lineWidth: CGFloat = 1
        let dashHeight: CGFloat = 3
        let dashLength: CGFloat = 3
        let dashColor: NSColor = .white
        
        let currentContext = NSGraphicsContext.current()!.cgContext
        currentContext.setLineWidth(lineWidth)
        currentContext.setLineDash(phase: 0, lengths: [dashLength])
        currentContext.setStrokeColor(dashColor.cgColor)
        
        currentContext.addRect(bounds.insetBy(dx: dashHeight, dy: dashHeight))
        currentContext.strokePath()
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            delegate?.draggingDidEnter()
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
        delegate?.draggingDidExit()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        delegate?.draggingDidEnd()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!
        self.filePath = path
        delegate?.droppingDidComplete(path: filePath)
        
        return true
    }
}
