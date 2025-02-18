//
//  LocalAppManager.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

class LocalAppInfo: ObservableObject, Hashable {
    @Published var name: String
    @Published var bundleId: String
    @Published var version: String
    @Published var icon: Image
    @Published var isAppActivated: Bool
    
    var executePath: String // 可执行文件路径   "/Applications/Permute 3.app/Contents/MacOS/Permute 3"
    var appName: String // 这个是 /Applications/?.app/Contents 这个地方的名字 "Permute 3.app"
    var appFolder: String // 这个是  "/Applications/Permute 3.app"
    let x64: Bool
    let anyVersion: Bool
    let hookUrl: Bool
    let supportVersion: String
    let remark: String
    let canActivate: Bool
    let licenseUser: String
    let licenseCode: String
    let mas: Bool
    
    init(name: String, bundleId: String, version: String, icon: Image, isAppActivated: Bool, executePath: String, appName: String, appFolder: String, x64: Bool, anyVersion: Bool, hookUrl: Bool, supportVersion: String, remark: String, canActivate: Bool, licenseUser: String, licenseCode: String, mas: Bool) {
        self.name = name
        self.bundleId = bundleId
        self.version = version
        self.icon = icon
        self.isAppActivated = isAppActivated
        self.executePath = executePath
        self.appName = appName
        self.appFolder = appFolder
        self.x64 = x64
        self.anyVersion = anyVersion
        self.hookUrl = hookUrl
        self.supportVersion = supportVersion
        self.remark = remark
        self.canActivate = canActivate
        self.licenseUser = licenseUser
        self.licenseCode = licenseCode
        self.mas = mas
    }
    
    // Hashable 协议要求实现以下方法：
    static func == (lhs: LocalAppInfo, rhs: LocalAppInfo) -> Bool {
        return lhs.bundleId == rhs.bundleId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(bundleId)
    }
}

class LocalAppManager: ObservableObject {
    static let shared = LocalAppManager()
    
    @Published var localApps: [LocalAppInfo] = []
    @Published var isLoading: Bool = true
    
    private init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        initApps { [weak self] appInfos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.localApps = appInfos.sorted(using: KeyPathComparator(\.name))
                self.isLoading = false
            }
        }
    }
    
    func isAppFolder(_ str: String) -> Bool {
        let temp = str.components(separatedBy: ".")
        if temp.count < 2 {
            return false
        } else {
            if temp[temp.count - 1] == "app" {
                return true
            } else {
                return false
            }
        }
    }
    
    func initApps(completion: @escaping ([LocalAppInfo]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var newAppInfoArray = [LocalAppInfo]()
            let fileManager = FileManager.default
            
            let applicationDirectories = [
                "/Applications",
                "/Applications/Setapp",
            ]
            
//            print("这里调用了Local的initApps")
//            print(SupportedAppManager.shared.supportedApps.count)
            if SupportedAppManager.shared.supportedApps.count == 0 {
                return
            }
            for directory in applicationDirectories {
                guard let appPaths = try? fileManager.contentsOfDirectory(atPath: directory) else {
                    continue
                }
                
                for appPath in appPaths {
                    if !self.isAppFolder(appPath) { continue }
                    
                    guard let bundle = Bundle(path: "\(directory)/\(appPath)") else { continue }
                    
                    let appInfo = self.createLocalAppInfo(
                        directory: directory,
                        appPath: appPath,
                        bundle: bundle
                    )
                    
                    newAppInfoArray.append(appInfo)
                }
            }
            
            // 在后台线程完成后，切换到主线程调用完成回调
            DispatchQueue.main.async {
                completion(newAppInfoArray)
            }
        }
    }
    
    private func createLocalAppInfo(directory: String, appPath: String, bundle: Bundle) -> LocalAppInfo {
        let appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
        let appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let bundleID = bundle.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? "Unknown"
        let executablePath = bundle.executableURL?.path ?? ""
        
        // 获取图标文件名
        let iconFileRaw = bundle.object(forInfoDictionaryKey: "CFBundleIconFile") as? String ??
            bundle.object(forInfoDictionaryKey: "CFBundleIconName") as? String
        let iconFile = iconFileRaw?.hasSuffix(".icns") == true ? iconFileRaw : iconFileRaw?.appending(".icns")
        let iconImage = loadAppIcon(directory: directory, appPath: appPath, iconFile: iconFile)
        
        // 获取支持的应用信息
        let supportedInfo = getSupportedAppInfo(bundleID: bundleID, executablePath: executablePath)
        
        return LocalAppInfo(
            name: appName,
            bundleId: bundleID,
            version: appVersion,
            icon: iconImage,
            isAppActivated: supportedInfo.isAppActivated,
            executePath: executablePath,
            appName: appPath,
            appFolder: "\(directory)/\(appPath)",
            x64: supportedInfo.supportedX86,
            anyVersion: supportedInfo.supportAllVersion,
            hookUrl: supportedInfo.hookUrl,
            supportVersion: supportedInfo.supportVersion,
            remark: supportedInfo.remark,
            canActivate: supportedInfo.canActivate,
            licenseUser: supportedInfo.licenseUser,
            licenseCode: supportedInfo.licenseCode,
            mas: supportedInfo.mas
        )
    }

    private func loadAppIcon(directory: String, appPath: String, iconFile: String?) -> Image {
        guard let iconFile = iconFile else {
            return Image(systemName: "questionmark.square")
        }
        
        let iconFilePath = "\(directory)/\(appPath)/Contents/Resources/\(iconFile)"
        if let nsImage = NSImage(contentsOfFile: iconFilePath) {
            return Image(nsImage: nsImage)
        }
        return Image(systemName: "questionmark.square")
    }

    private func getSupportedAppInfo(bundleID: String, executablePath: String) -> (supportedX86: Bool, supportAllVersion: Bool, hookUrl: Bool, supportVersion: String, remark: String, canActivate: Bool, isAppActivated: Bool, licenseUser: String, licenseCode: String, mas: Bool) {
        for supportedApp in SupportedAppManager.shared.supportedApps {
            if supportedApp.bundleId == bundleID {
                return (
                    supportedX86: supportedApp.x86,
                    supportAllVersion: supportedApp.anyVersion,
                    hookUrl: supportedApp.hookUrl ?? false,
                    supportVersion: supportedApp.anyVersion ? "All Version" : supportedApp.version,
                    remark: supportedApp.remark ?? "",
                    canActivate: true,
                    isAppActivated: isAppActivated(executablePath),
                    licenseUser: supportedApp.licenseUser ?? "",
                    licenseCode: supportedApp.licenseCode ?? "",
                    mas: supportedApp.MAS
                )
            }
        }
        return (false, false, false, "", "", false, false, "", "", false)
    }
    
    private func isAppActivated(_ executablePath: String) -> Bool {
//        let appPath = executablePath.replacingOccurrences(of: " ", with: "\\\\ ")
//        let otoolOutput = Utils.runSudoShellCommandByScript("/usr/bin/otool -L \(appPath)", sudo: false)
//
//        guard let output = otoolOutput else {
//            return false
//        }
//        if output.contains(Constants.dylibName) {
//            return true
//        } else {
//            return false
//        }
        
        var url = URL(fileURLWithPath: executablePath)
        url.deleteLastPathComponent() // 删除最后的文件名
        print(url)
        
        let fileManager = FileManager.default
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: url.path)
            for fileName in fileNames {
                if fileName.contains("libTrialMacApp") {
                    return true
                }
            }
        } catch {
            print("Error while enumerating files at path \(executablePath): \(error.localizedDescription)")
            return false
        }
        return false
    }
}
