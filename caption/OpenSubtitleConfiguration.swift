//
//  Configuration.swift
//  caption
//
//  Created by Wouter van de Kamp on 14/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa

struct OpenSubtitleConfiguration {
    static let secureBaseURL = URL(string: "https://api.opensubtitles.org:443/xml-rpc")
    static let userAgent = "OSTestUserAgentTemp"
    static var token: String?
}
