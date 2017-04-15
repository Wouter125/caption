//
//  OpenSubtitleDownloadHandler.swift
//  caption
//
//  Created by Wouter van de Kamp on 12/04/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa
import AlamofireXMLRPC
import Gzip

class OpenSubtitleDownloadHandler {
    typealias convertDownloadCompletion = (Data) -> ()
    
    let base64Str: String
    var decompressedData: Data
    
    init(base64Str: String, decompressedData: Data) {
        self.base64Str = base64Str
        self.decompressedData = decompressedData
    }

    
    func convertDownload(completion: @escaping convertDownloadCompletion) {
        //let base64Str = download["data"] as! String
        let decodedData = Data(base64Encoded: base64Str)!
        if decompressedData.isGzipped {
            decompressedData = try! decodedData.gunzipped()
            completion(decompressedData)
        } else {
            decompressedData = decodedData
            print("not decompressed")
        }
    }
    

}
