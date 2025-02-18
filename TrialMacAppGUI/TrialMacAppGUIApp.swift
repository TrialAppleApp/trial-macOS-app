//
//  TrialMacAppGUIApp.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 10/22/24.
//

import Sparkle
import SwiftUI

@main
struct TrialMacAppGUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: UpdaterManager.shared.updater)
            }
            
            CommandGroup(replacing: .help) {
                Link("GitHub", destination: URL(string: "https://github.com/TrialAppleApp/trial-macOS-app/")!)
            }
        }
        Settings {
            SettingsView()
        }
    }
}
