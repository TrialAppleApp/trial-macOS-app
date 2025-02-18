//
//  AppDetailView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct AppDetailView: View {
    let localAppInfo: LocalAppInfo
    @StateObject var localappManager: LocalAppManager = .shared
    @State private var scriptLog: String = "" // Holds script execution logs
    @State private var scriptLogs: [String] = []
    @State private var isRunningScript: Bool = false // Indicates if the script is being executed
    
    @State var password: String = ""
    @State var isRunning: Bool = false // 是否在执行注入操作
    
    @State var dylib: Constants.injectDylib = .general
    
    @State var showLicense: Bool = false
    @AppStorage("savePasswordMethod") private var savePasswordMethod: SavePasswordMethod = .keychain
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // App Icon and Information Section
                appInfoSection
                
                appInfoDetailsSection
                Divider()
                
                // Action Buttons Section
                actionButtonsSection
                
                Divider()
                
                // Script Log Output Section
                logOutputSection
            }
            .padding()
        }
        .sheet(isPresented: $showLicense) {
            licenseInfoView(user: localAppInfo.licenseUser, code: localAppInfo.licenseCode)
        }
        .onChange(of: localAppInfo) { _ in
            scriptLogs = []
        }
    }
        
    private var appInfoDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 支持信息部分
            HStack {
                Label("Supports x64", systemImage: localAppInfo.x64 ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(localAppInfo.x64 ? .green : .red)
                Label(localAppInfo.anyVersion ? "Any Version" : (localAppInfo.supportVersion == "" ? "Not Support" : localAppInfo.supportVersion), systemImage: localAppInfo.canActivate ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(localAppInfo.canActivate ? .green : .red)
                
                Label("Mac App Store", systemImage: localAppInfo.mas ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(localAppInfo.mas ? .green : .red)
            }
            .font(.subheadline)
            
            // 其他信息
            if !localAppInfo.remark.isEmpty {
                HStack {
                    Text("Remark: ")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    Text(localAppInfo.remark)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - App Info Section

    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 16) {
                localAppInfo.icon // Display the app icon
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(localAppInfo.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(localAppInfo.bundleId)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Version: \(localAppInfo.version)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Action Buttons Section

    private var actionButtonsSection: some View {
        HStack {
            Button {
                DispatchQueue.global(qos: .userInitiated).async {
                    // 使用后台线程执行打开 App 的操作
                    NSWorkspace.shared.open(URL(fileURLWithPath: localAppInfo.appFolder))
                }
            } label: {
                Label("Run App", systemImage: "play.circle")
            }
            .buttonStyle(.bordered)
            
            Button {
                DispatchQueue.global(qos: .userInitiated).async {
                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: localAppInfo.appFolder + "/Contents")
                }
            } label: {
                Label("Open in Finder", systemImage: "folder")
            }
            .buttonStyle(.bordered)
            
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(localAppInfo.bundleId, forType: .string)
            } label: {
                Label("Copy Bundle ID", systemImage: "document.on.document")
            }
            .buttonStyle(.bordered)
            
            if localAppInfo.canActivate {
                Button {
                    startTrial()
                } label: {
                    Label(localAppInfo.isAppActivated ? "Processed" : "Start activate", systemImage: "bolt.circle")
                }
                .buttonStyle(.bordered)
                .disabled(localAppInfo.isAppActivated)
            }
            
            if localAppInfo.licenseCode != "" {
                Button {
                    showLicense.toggle()
                } label: {
                    Label("Show license", systemImage: "info.bubble")
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    // MARK: - Script Log Output Section

    private var logOutputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Output Log")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if scriptLogs.isEmpty {
                        Text("No logs yet")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(scriptLogs, id: \.self) { log in
                            Text(log)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled) // 支持选中和复制
                        }
                    }
                }
                .padding(8)
            }
            .frame(minHeight: 200) // 设置最小高度
            .background(Color.gray.opacity(0.1)) // 背景颜色
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private func setupInitialLogs() {
        scriptLogs.append("Started monitoring \(localAppInfo.name)")
        scriptLogs.append("Bundle identifier: \(localAppInfo.bundleId)")
    }
    
    // 判断版本是否支持
//    private func versionCheck() -> Bool {
//        for app in localappManager.localApps {
//            if app.bundleId == localAppInfo.bundleId {
//                if app.anyVersion {
//                    return true
//                }
//            }
//        }
//    }

    func isAppSupported() -> Bool {
        var isSupported = false
        for app in localappManager.localApps {
            if app.bundleId == localAppInfo.bundleId {
                #if arch(x86_64)
                    if app.x64 {
                        isSupported = true
                    }
                #elseif arch(arm64)
                    isSupported = true
                #endif
                break
            }
        }
        return isSupported
    }
    
    func startTrial() {
        isRunning = true
        // 获取保存的密码
        
        var savedPwd: String?
        switch savePasswordMethod {
        case .keychain:
            savedPwd = KeychainPasswordSaver.shared.getPassword()
        case .userDefaults:
            savedPwd = UserDefaultsPasswordSaver.shared.getPassword()
        }
        guard let savedPwd else {
            scriptLogs.append("Error: \(NSLocalizedString("Your password has not been obtained. Click the upper right corner to save your password.", comment: ""))")
            isRunning = false
            return
        }
        
        let pwdValidated = Utils.checkPassword(password: savedPwd)
        if !pwdValidated {
            scriptLogs.append("Error: \(NSLocalizedString("Wrong password, click the upper right corner to re-enter the password", comment: ""))")
            isRunning = false
            return
        }
        password = savedPwd
        
        if !isAppSupported() {
            scriptLogs.append("Error: \(NSLocalizedString("This application is not supported or your system architecture is not supported", comment: ""))")
            isRunning = false
            return
        }
        
        if localAppInfo.hookUrl {
            dylib = .url
        } else if !localAppInfo.anyVersion {
            dylib = .code
        }
        
        if localAppInfo.executePath == "" {
            scriptLogs.append("Error: \(NSLocalizedString("This is an anomaly, it is missing important information, you can report it to GitHub", comment: ""))")
            isRunning = false
            return
        }
        
        let taskList = [copyDylib, optool, codesign, xattr]
        executeTaskSequence(tasks: taskList) { [self] success in
            isRunning = false
            if success {
                scriptLogs.append(NSLocalizedString("🎉 All tasks completed successfully!", comment: ""))
                localAppInfo.isAppActivated = true
            } else {
                scriptLogs.append("Error: \(NSLocalizedString("❌ Task failed. Execution stopped.", comment: ""))")
            }
        }
    }
    
    private func fixPath(path: String) -> String {
        return path.replacingOccurrences(of: " ", with: "\\\\ ")
    }
    
    private func copyDylib() -> (String, Bool) {
        let appFolder = fixPath(path: localAppInfo.appFolder)
        let command = "cp \(dylib.pathString) \(appFolder)/Contents/MacOS"
        var success = false
        
        if let output = Utils.runSudoShellCommandByScriptWithPwd(command, password: password) {
            if output.contains("not permitted") || output.contains("not allowed") {
                scriptLogs.append("Error: \(NSLocalizedString("Activation error - 00", comment: ""))")
            } else {
                success = true
            }
        }
        let task = NSLocalizedString("Process the dylib file", comment: "")
        return (task, success)
    }
    
    private func optool() -> (String, Bool) {
        let appName = fixPath(path: localAppInfo.executePath)
        let command = "\(Constants.cmdOptoolPath) install -p @executable_path/\(dylib.name).dylib -t \(appName)"
        var success = false
        
        if let output = Utils.runSudoShellCommandByScriptWithPwd(command, password: password) {
            if output.contains("not permitted") || output.contains("not allowed") {
                scriptLogs.append("Error: \(NSLocalizedString("Activation error - 01", comment: ""))")
            } else {
                success = true
            }
        }
        let task = NSLocalizedString("Injecting Dependencies", comment: "")
        return (task, success)
    }
    
    private func codesign() -> (String, Bool) {
        let appName = fixPath(path: localAppInfo.appName)
        var command = ""
        if localAppInfo.bundleId == "com.massimobiolcati.irealbookmac" {
            command = "codesign -f -s - --all-architectures Applications/\(appName)"
        } else {
            command = "codesign -f -s - --all-architectures --deep /Applications/\(appName)"
        }
        var success = false
        
        if let output = Utils.runSudoShellCommandByScriptWithPwd(command, password: password) {
            if output.contains("not permitted") || output.contains("not allowed") {
                scriptLogs.append("Error: \(NSLocalizedString("Activation error - 02", comment: ""))")
            } else {
                success = true
            }
        }
        let task = NSLocalizedString("Execution Signature", comment: "")
        return (task, success)
    }
    
    private func xattr() -> (String, Bool) {
        let appName = fixPath(path: localAppInfo.appName)
        let command = "xattr -cr /Applications/\(appName)"
        var success = false
        
        if let output = Utils.runSudoShellCommandByScriptWithPwd(command, password: password) {
            if output.contains("not permitted") || output.contains("not allowed") {
                scriptLogs.append("Error: \(NSLocalizedString("Activation error - 03", comment: ""))")
            } else {
                success = true
            }
        }
        let task = NSLocalizedString("Removing permissions", comment: "")
        return (task, success)
    }
    
    // 串行执行任务的辅助函数
    private func executeTaskSequence(tasks: [() -> (String, Bool)], completion: @escaping (Bool) -> Void) {
        guard !tasks.isEmpty else {
            completion(true)
            return
        }

        var remainingTasks = tasks
        let currentTask = remainingTasks.removeFirst()

        DispatchQueue.global().async {
            let (message, success) = currentTask() // 解构返回的消息和成功状态
            
            DispatchQueue.main.async {
                if success {
                    scriptLogs.append(String(format: NSLocalizedString("✅ Task %@ completed successfully.", comment: ""), message))
                    self.executeTaskSequence(tasks: remainingTasks, completion: completion)
                } else {
                    scriptLogs.append(String(format: NSLocalizedString("❌ Task %@ failed.", comment: ""), message))
                    completion(false)
                }
            }
        }
    }
}

struct licenseInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    let user: String
    let code: String
    
    var body: some View {
        HStack {
            Text("License user: \(user)")
                .font(.headline)
                .padding()
            
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(user, forType: .string)
            } label: {
                Label("Copy", systemImage: "square.and.arrow.up")
            }
        }
        
        HStack {
            Text("License code: \(code)")
                .font(.headline)
                .padding()
            
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(code, forType: .string)
            } label: {
                Label("Copy", systemImage: "square.and.arrow.up")
            }
        }
        
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Close")
            }
            .padding(.bottom, 16)
            .padding(.trailing, 16)
        }
    }
}
