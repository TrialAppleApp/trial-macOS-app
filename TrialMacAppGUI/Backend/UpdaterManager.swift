//
//  UpdaterManager.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/10/24.
//

import Sparkle

class UpdaterManager {
    static let shared = UpdaterManager()
    let updater: SPUUpdater

    private init() {
        let controller = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        self.updater = controller.updater
    }
}
