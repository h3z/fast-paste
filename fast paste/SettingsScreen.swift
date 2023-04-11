//
//  SettingsScreen.swift
//  fast paste
//
//  Created by hzzz on 2023/4/11.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Toggle Unicorn Mode:", name: .toggleUnicornMode)
        }
    }
}
