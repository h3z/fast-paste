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
            if appState.isUnicornMode {
                ContentView()
            }
        }
        Settings {
            SettingsScreen()
        }
    }
}


@MainActor
final class AppState: ObservableObject {
    @Published var isUnicornMode: Bool = false
    init() {
        KeyboardShortcuts.onKeyUp(for: .toggleUnicornMode) { [self] in
            isUnicornMode.toggle()
        }
    }
}
