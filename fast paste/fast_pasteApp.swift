//
//  fast_pasteApp.swift
//  fast paste
//
//  Created by hzzz on 2023/4/11.
//

import SwiftUI
import KeyboardShortcuts



@main
struct fast_pasteApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()

        }
        Settings {
            SettingsScreen()
        }
    }
}


@MainActor
final class AppState: ObservableObject {
    var isUnicornMode: Bool = false
    init() {
        KeyboardShortcuts.onKeyUp(for: .toggleUnicornMode) { [self] in
            isUnicornMode.toggle()
            print(isUnicornMode)
            if isUnicornMode {
                NSApp.activate(ignoringOtherApps: true)
            } else {
                NSApp.hide(nil)
            }
        }
    }
}
