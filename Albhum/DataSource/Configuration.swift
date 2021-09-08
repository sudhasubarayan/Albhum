//
//  Configuration.swift
//  Albhum
//
//  Created by Sudha on 08/09/21.
//

import Foundation

// Application configuration details
class Configuration {
    
    //Created singleton object to access application configuration
    static let sharedInstance = Configuration()
    
    //Hold data from the configuration.plist file that contains api details
    let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Configuration", ofType: "plist")!)
    
    // URL
    static func getAPI () ->String
    {
        return sharedInstance.dict!["API"] as! String
    }
}
