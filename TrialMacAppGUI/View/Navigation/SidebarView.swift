//
//  SidebarView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct SidebarView: View {
    @Binding var searchText: String // 搜索框内容
    @Binding var selectedApp: LocalAppInfo?
    @Binding var isSupported: Bool

    @EnvironmentObject var localappManager: LocalAppManager
    @State private var localApps: [LocalAppInfo] = []

    var filteredApps: [LocalAppInfo] {
        if searchText.isEmpty && !isSupported {
            return localApps
        } else if !searchText.isEmpty && !isSupported {
            return localApps.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else if searchText.isEmpty && isSupported {
            return localApps.filter { $0.canActivate }
        } else {
            return localApps.filter {
                $0.name.lowercased().contains(searchText.lowercased()) && $0.canActivate
            }
        }
    }

    var body: some View {
        if localappManager.isLoading {
            ProgressView("Scanning Apps...")
        } else {
            List(filteredApps, id: \.bundleId) { app in
                ZStack(alignment: .leading) {
                    if selectedApp?.bundleId == app.bundleId {
                        Rectangle()
                            .fill(Color(NSColor.selectedContentBackgroundColor))
                            .cornerRadius(8)
                    }
                    HStack {
                        app.icon
                            .resizable()
                            .frame(width: 32, height: 32)
                            .cornerRadius(4)
                        VStack(alignment: .leading) {
                            HStack {
                                Text(app.name)
                                    .font(.headline)

                                Label("Processed", systemImage: "checkmark.circle.fill")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                                    .labelStyle(.iconOnly)
                                    .opacity(app.isAppActivated ? 1 : 0)
                            }

                            Text(app.bundleId)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(app.version)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedApp = app
                }
            }
            .listStyle(SidebarListStyle())
            .onReceive(localappManager.$localApps) { newApps in
                localApps = newApps
            }
        }
    }
}
