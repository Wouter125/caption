//
//  OpenSubtitleDataManager.swift
//  caption
//
//  Created by Wouter van de Kamp on 25/03/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireXMLRPC

class OpenSubtitleDataManager {
    typealias opensubtitleDataCompletion = (XMLRPCNode) -> ()
    
    let secureBaseURL: URL
    let osMethod: String
    let parameters: [Any]
    
    init(secureBaseURL: URL, osMethod: String, parameters: [Any]) {
        self.secureBaseURL = secureBaseURL
        self.osMethod = osMethod
        self.parameters = parameters
    }
    
    func fetchOpenSubtitleData(completion: @escaping opensubtitleDataCompletion) {
        AlamofireXMLRPC.request(secureBaseURL, methodName: osMethod, parameters: parameters).responseXMLRPC { (response: DataResponse<XMLRPCNode>) -> Void in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
