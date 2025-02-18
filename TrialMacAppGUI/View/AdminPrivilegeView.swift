//
//  AdminPrivilegeView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/7/24.
//

import SwiftUI

struct AdminPrivilegeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var password: String = ""
    @AppStorage("showAdminPrivilegeView") private var showAdminPrivilegeView: Bool = true
    @AppStorage("savePasswordMethod") private var savePasswordMethod: SavePasswordMethod = .keychain

    @State private var errorMessage: String?
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HeaderView()
            PasswordInputView(password: $password, errorMessage: $errorMessage)
            ActionButtons()
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 250)
    }

    @ViewBuilder
    private func ActionButtons() -> some View {
        HStack {
            Button(action: submitPassword) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Submit")
                }
            }
            .keyboardShortcut(.defaultAction)
            .disabled(isLoading)

            Button("View only without operation", action: dismiss.callAsFunction)
        }
        .padding(.bottom, 10)
    }

    private func submitPassword() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            let success = await checkAndSavePassword(password: password)
            if success {
                showAdminPrivilegeView = false
            }
            isLoading = false
        }
    }

    private func checkAndSavePassword(password: String) async -> Bool {
        guard Utils.checkPassword(password: password) else {
            errorMessage = String(localized: "Your password is incorrect, please check and try again.")
            return false
        }

        let saved = switch savePasswordMethod {
        case .keychain: KeychainPasswordSaver.shared.savePassword(password)
        case .userDefaults: UserDefaultsPasswordSaver.shared.savePassword(password)
        }

        if saved {
            print("密码保存成功")
            return true
        } else {
            errorMessage = String(localized: "Failed to save password, please try again.")
            return false
        }
    }
}

private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("Please enter your password to continue.")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text("Your password will be saved in the system keychain.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

private struct PasswordInputView: View {
    @Binding var password: String
    @Binding var errorMessage: String?

    var body: some View {
        VStack {
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .controlSize(.large)
                .padding()
                .autocorrectionDisabled()
                .onChange(of: password) { _ in errorMessage = nil }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    AdminPrivilegeView()
}
