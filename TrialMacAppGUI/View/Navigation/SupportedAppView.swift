//
//  SupportedAppView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct SupportedAppView: View {
    @Binding var supportedApps: [SupportedApp]

    @Environment(\.dismiss) var dismiss

    @State var order: [KeyPathComparator<SupportedApp>] = [.init(\.name, order: .forward)] // 排序条件

    var body: some View {
        NavigationStack {
            VStack {
                if supportedApps.isEmpty {
                    ProgressView("Loading...")
                } else {
                    tableView
                }
            }
            .task {
                supportedApps.sort(using: order)
            }
            .navigationTitle("All Supported Apps") // 主标题
            .navigationSubtitle("You can right-click to copy the name and remarks") // 副标题
        }
        .toolbar { // 替换自己实现的Button，这里可以加更多自定义功能导航到 placement可查看
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }

    private var tableView: some View {
        Table(supportedApps, sortOrder: $order) {
            TableColumn("Name") { app in
                CopyableText(value: app.name)
            }

            TableColumn("MAS") {
                Text($0.MAS ? "✅" : "")
            }
            .width(32)

            TableColumn("X86") {
                Text($0.x86 ? "✅" : "❌")
            }
            .width(32)

            TableColumn("Version") {
                Text($0.anyVersion ? "✅" : $0.version)
            }
            .width(72)

            TableColumn("Remark") { app in
                CopyableText(value: app.remark ?? "")
            }
        }
        .padding(.top, 6)
        .frame(width: 660, height: 300) // ？？？？
        .onChange(of: order) { newOrder in
            print(newOrder)
            withAnimation {
                supportedApps.sort(using: newOrder) // 排序条件改变时对数据重排序
            }
        }
        .tableStyle(.inset)
    }

    struct CopyableText<T>: View where T: CustomStringConvertible {
        let value: T

        var body: some View {
            Text(value.description)
                .contextMenu {
                    Button("Copy") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(value.description, forType: .string)
                    }
                }
        }
    }
}
