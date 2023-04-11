//
//  ContentView.swift
//  fast paste
//
//  Created by hzzz on 2023/4/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State var clipboardEntries = ["Hello","Hello2", "World"]
    @State var lastChangeCount: Int = 0
    @State var searchText = ""
    @State var selection = 0
    let pasteboard: NSPasteboard = .general
    
    
    var filteredClipboardEntries: [String] {
        clipboardEntries.filter {
            searchText.isEmpty ? true : $0.localizedStandardContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                selection = 0
            })
            .onChange(of: appState.need_clear_search) { newValue in
                searchText = ""
                appState.need_clear_search = false
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            Divider()
            List(selection: $selection) {
                ForEach(filteredClipboardEntries.indices, id: \.self) { index in
                    Text(filteredClipboardEntries[index]).tag(index)
                }
            }
            .padding()
            .onAppear {
                startTimer()
                addLocalMonitorForEvents()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didHideNotification)) { _ in
                searchText = ""
            }
        }
        
    }
    
    func addLocalMonitorForEvents() {
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { nsevent in
            print(nsevent.keyCode)
            if nsevent.keyCode == 125 {
                selection = selection < filteredClipboardEntries.count - 1 ? selection + 1 : selection
            } else if nsevent.keyCode == 126 {
                selection = selection > 0 ? selection - 1 : selection
            } else if nsevent.keyCode == 36 {
                pasteboard.clearContents()
                pasteboard.setString(filteredClipboardEntries[selection], forType: .string)
                NSApp.hide(nil)
                print(appState.sourceApp)
                
                let pasteboard = NSPasteboard.general
                if let string = pasteboard.string(forType: .string) {
                    print("粘贴板内容：\(string)")
                    appState.sourceApp.activate(options: .activateIgnoringOtherApps)
                    let source = CGEventSource(stateID: .hidSystemState)
                    let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true)
                    keyDown?.flags = CGEventFlags.maskCommand
                    let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false)
                    keyUp?.flags = CGEventFlags.maskCommand
                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }
            return nsevent
        }
    }
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if self.lastChangeCount != self.pasteboard.changeCount {
                self.lastChangeCount = self.pasteboard.changeCount
                if let read = self.pasteboard.string(forType: .string) {
                    clipboardEntries.append(read)
                }
            }
            if let frontmostApp = NSWorkspace.shared.frontmostApplication {
                if frontmostApp.bundleIdentifier != Bundle.main.bundleIdentifier && !NSApp.isHidden{
                    print("auto hide")
                    NSApp.hide(nil)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
