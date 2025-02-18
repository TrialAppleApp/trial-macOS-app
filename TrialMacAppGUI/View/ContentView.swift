//
//  ContentView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("showAdminPrivilegeView") private var showAdminPrivilegeView: Bool = false
    @StateObject var supportedAppManager: SupportedAppManager = .shared
    @StateObject var localappManager: LocalAppManager = .shared
    @State var supportedApps: [SupportedApp] = []

    @State private var isShowAllSupportedApp = false // sheet显示

    @State private var selectedApp: LocalAppInfo?
    @State private var searchText: String = ""
    @State private var isSupported: Bool = false

    var body: some View {
        NavigationSplitView {
            SidebarView(searchText: $searchText, selectedApp: $selectedApp, isSupported: $isSupported)
                .environmentObject(localappManager)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isSupported.toggle()
//                            print(isSupported)
                        } label: {
                            Label("filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }

                    ToolbarItem(placement: .secondaryAction) {
                        Spacer()
                    }
                }
        } detail: {
            if let app = selectedApp {
                AppDetailView(localAppInfo: app)
            } else {
                AboutView()
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .status) {
//                Text("Status: Online")
//                    .foregroundColor(.green)
//            }
//        }
        .toolbar {
            toolbarContent
        }
        .sheet(isPresented: $isShowAllSupportedApp) {
            SupportedAppView(supportedApps: $supportedApps)
        }
        .sheet(isPresented: $showAdminPrivilegeView) {
            AdminPrivilegeView()
        }
        .task {
            supportedApps = supportedAppManager.getSupportedApps()
            localappManager.loadData()
        }
        .searchable(text: $searchText, placement: .sidebar)
        .navigationTitle(selectedApp != nil ? "App Details" : "TrialMacAppGUI")
        .alert(item: $supportedAppManager.errorMessage) { msg in
            Alert(
                title: Text("Fatal errors please report immediately"),
                message: Text(msg.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // 功能合集
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                let windowController = UpdateLogWindowController()
                windowController.show()
            } label: {
                Label("Update Logs", systemImage: "info.bubble.rtl")
            }

            Button {
                showAdminPrivilegeView = true
            } label: {
                Label("Enter password again", systemImage: "lock")
            }

            Button {
                localappManager.loadData()
                selectedApp = nil
                searchText = ""
            } label: {
                Label("Refresh app list", systemImage: "arrow.clockwise")
            }

            Button {
                isShowAllSupportedApp.toggle()
            } label: {
                Label("Supported apps", systemImage: "list.clipboard")
            }
        }
    }
}
