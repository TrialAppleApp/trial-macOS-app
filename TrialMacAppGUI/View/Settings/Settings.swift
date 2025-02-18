//
//  Settings.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import Sparkle
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 0) {
            TabView {
                GeneralView()
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
            }
            .padding()
        }
        .frame(width: 500, height: 400)
    }
}
