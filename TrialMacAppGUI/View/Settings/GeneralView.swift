//
//  GeneralView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import Sparkle
import SwiftUI

struct GeneralView: View {
    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool
    @AppStorage("savePasswordMethod") private var savePasswordMethod: SavePasswordMethod = .keychain
    
    private let updater: SPUUpdater
    
    init() {
        self.updater = UpdaterManager.shared.updater
        _automaticallyChecksForUpdates = State(initialValue: updater.automaticallyChecksForUpdates)
        _automaticallyDownloadsUpdates = State(initialValue: updater.automaticallyDownloadsUpdates)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                Divider()
                updateSettings
                Divider()
                passwordSettings
            }
            .padding()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Constants.appName)
                .font(.title2)
                .bold()
            Text("Welcome")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var updateSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Update Settings")
                .font(.title3)
                .bold()
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle(isOn: $automaticallyChecksForUpdates) {
                    Label("Automatically check for updates", systemImage: "arrow.down.circle")
                }
                .onChange(of: automaticallyChecksForUpdates) { newValue in
                    updater.automaticallyChecksForUpdates = newValue
                }
                
                Toggle(isOn: $automaticallyDownloadsUpdates) {
                    Label("Automatically download updates", systemImage: "arrow.down.square")
                }
                .disabled(!automaticallyChecksForUpdates)
                .onChange(of: automaticallyDownloadsUpdates) { newValue in
                    updater.automaticallyDownloadsUpdates = newValue
                }
            }
        }
    }
    
    private var passwordSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Save Password Settings")
                .font(.title3)
                .bold()
            
            Picker("Save Password Using", selection: $savePasswordMethod) {
                Text("Keychain").tag(SavePasswordMethod.keychain)
                Text("User Defaults").tag(SavePasswordMethod.userDefaults)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(.top, 8)
            
            Text(savePasswordMethodDescription)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
    }

    private var savePasswordMethodDescription: String {
        switch savePasswordMethod {
        case .keychain:
            return "Your password will be securely stored in the Keychain."
        case .userDefaults:
            return "Your password will be stored in User Defaults (less secure)."
        }
    }
}
