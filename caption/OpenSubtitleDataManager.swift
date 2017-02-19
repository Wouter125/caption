//
//  DataManager.swift
//  caption
//
//  Created by Wouter van de Kamp on 14/02/2017.
//  Copyright © 2017 Wouter van de Kamp. All rights reserved.
//

import Cocoa
import wpxmlrpc

enum DataManagerError: Error {
    case Unknown
    case FailedRequest
    case InvalidResponse
}

final class OpenSubtitleDataManager {
    typealias opensubtitleDataCompletion = (Any?, DataManagerError?) -> ()
    let secureBaseURL: URL
    let osMethod: String
    let parameters: [Any]
    
    // MARK: = Initialization
    init(secureBaseURL: URL, osMethod: String, parameters: [Any]) {
        self.secureBaseURL = secureBaseURL
        self.osMethod = osMethod
        self.parameters = parameters
    }
    
    // MARK: - Requesting Data
    func osData(completion: @escaping opensubtitleDataCompletion) {
        var request = URLRequest(url: secureBaseURL)
        request.httpMethod = "POST"
        
        let encoder = WPXMLRPCEncoder(method: osMethod, andParameters: parameters)
        request.httpBody = try! encoder?.dataEncoded()
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            self.didFetchOSData(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func didFetchOSData(data: Data?, response: URLResponse?, error: Error?, completion: opensubtitleDataCompletion) {
        if let _  = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processOSData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
        }
    }
    
    func processOSData(data: Data, completion: opensubtitleDataCompletion) {
        let decoder = WPXMLRPCDecoder(data: data)
        if (decoder?.isFault())! {
            print(decoder?.faultString()! as Any)
        } else {
            completion(decoder?.object(), nil)
        }
    }
}

