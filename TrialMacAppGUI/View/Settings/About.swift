//
//  About.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 46)
            VStack(spacing: 4) {
                Image("Avatar")
                    .antialiased(true)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)

                Spacer().frame(height: 16)

                Text("Welcome to \(Constants.appName)")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                Text("By \(Constants.authorName) 🔥")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundColor(.secondary)

                Link(destination: URL(string: "https://github.com/TrialMacApp")!, label: {
                    Image(systemName: "link")
                    Text("Visit my GitHub page")
                })
                .font(.system(.body, design: .rounded, weight: .bold))
                .padding(.top, 10)

                Spacer().frame(height: 14)
            }
            Spacer()
            VStack {
                Text("It's completely free to use, if you have to pay to use it then you are being cheated!")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .opacity(0.5)
                    .padding(.bottom, 35)
            }
            .padding()
        }
        .frame(width: 560)
    }
}
