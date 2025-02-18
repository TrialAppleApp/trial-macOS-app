//
//  Constants.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import Foundation

enum Constants {
    static let appName = "TrialMacAppGUI"
    static let authorName = "TrialMacApp"
    static let authorHomepageUrl = URL(string: "https://github.com/TrialMacApp")!
    
//    static let dylibName = "libTrialMacApp.dylib"
    
    static let localOptoolPath = URL(string: Bundle.main.path(forResource: "optool", ofType: "") ?? "")!
    static let cmdOptoolPath = localOptoolPath.path.replacingOccurrences(of: " ", with: "\\\\ ")
    
    enum injectDylib {
        case general
        case code
        case url
        
        var name: String {
            switch self {
            case .general:
                return "libTrialMacApp"
            case .code:
                return "libTrialMacAppCode"
            case .url:
                return "libTrialMacAppUrl"
            }
        }
        
        var path: URL? {
            if let path = Bundle.main.path(forResource: name, ofType: "dylib") {
                return URL(fileURLWithPath: path)
            }
            return nil
        }
            
        var pathString: String {
            path?.path.replacingOccurrences(of: " ", with: "\\\\ ") ?? ""
        }
    }
}
