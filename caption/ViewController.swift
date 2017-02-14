//
//  ViewController.swift
//  caption
//
//  Created by Wouter van de Kamp on 13/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var searchField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Clean this up. Don't leave it in viewDidLoad. Prefer to move it to a subclass. Inside CustomSearchField
        searchField.wantsLayer = true
        let textFieldLayer = CALayer()
        searchField.layer = textFieldLayer
        searchField.backgroundColor = NSColor.white
        searchField.layer?.backgroundColor = CGColor.white
        searchField.layer?.borderColor = CGColor.white
        searchField.layer?.borderWidth = 0
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

