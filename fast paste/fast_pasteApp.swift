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
            ContentView().environmentObject(appState)

        }
        Settings {
            SettingsScreen()
        }
    }
}


@MainActor
final class AppState: ObservableObject {
    @Published var sourceApp: NSRunningApplication = NSRunningApplication.current
    @Published var need_clear_search = false
    init() {
        KeyboardShortcuts.onKeyDown(for: .toggleUnicornMode) { [self] in
            if !NSApp.isActive {
                if let frontmostApp = NSWorkspace.shared.frontmostApplication {
                    self.sourceApp = frontmostApp
                    self.need_clear_search = true
                    print("Source App: \(self.sourceApp.localizedName ?? "")")
                }
                
                NSApp.activate(ignoringOtherApps: true)
                
            } else {
                NSApp.hide(nil)
//                if let frontmostApp = NSWorkspace.shared.frontmostApplication {
//                    print(frontmostApp)
//                    print("前台应用程序：\(frontmostApp.localizedName ?? "")")
//                    print("前台应用程序：\(frontmostApp.bundleIdentifier ?? "")")
//                }
            }
        }
    }
}
