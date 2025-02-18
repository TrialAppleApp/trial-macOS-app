//
//  SupportedAppManager.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

public struct SupportedApp: Codable, Equatable, Identifiable {
    public let id = UUID()
    let MAS: Bool
    let anyVersion: Bool
    let hookUrl: Bool?
    let bundleId: String
    let name: String
    let version: String
    let x86: Bool
    let remark: String?
    let licenseCode: String?
    let licenseUser: String?

    enum CodingKeys: String, CodingKey {
        case MAS
        case anyVersion
        case hookUrl
        case bundleId
        case name
        case version
        case x86
        case remark
        case licenseCode
        case licenseUser
    }
}

public struct SupportedAppErrMsg: Identifiable {
    public let id = UUID()
    public let message: String
}

class SupportedAppManager: ObservableObject {
    static let shared = SupportedAppManager()
    @Published private(set) var supportedApps: [SupportedApp] = []
    @Published var errorMessage: SupportedAppErrMsg? // 用于存储错误信息

    private init() {
        loadSupportedApps()
    }

    public func getSupportedApps() -> [SupportedApp] {
        supportedApps
    }

    func loadSupportedApps() {
        DispatchQueue.global(qos: .background).async {
            guard let infoDict = Bundle.main.infoDictionary else {
                self.reportError(SupportedAppErrMsg(message: NSLocalizedString("Error loading Info.plist: Info.plist not found.", comment: "")))
                return
            }
            guard let supportedAppsArray = infoDict["Supported Apps"] as? [[String: Any]] else {
                self.reportError(SupportedAppErrMsg(message: NSLocalizedString("Error: 'Supported Apps' key not found in Info.plist.", comment: "")))
                return
            }

            // 将字典数组转换为 JSON 数据
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: supportedAppsArray)
                let decoder = JSONDecoder()
                let supportedApps = try decoder.decode([SupportedApp].self, from: jsonData)

                DispatchQueue.main.async {
                    self.supportedApps = supportedApps // 更新 apps 属性
                    print("更新 SupportedAppManager.supportedApps")
                }
            } catch {
                self.reportError(SupportedAppErrMsg(message: NSLocalizedString("Error: Parsing data error: \(error)", comment: "")))
            }
        }
    }

    private func reportError(_ message: SupportedAppErrMsg) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
}
