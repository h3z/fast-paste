//
//  ContentView.swift
//  fast paste
//
//  Created by hzzz on 2023/4/11.
//

import SwiftUI

struct ContentView: View {
    @State var clipboardEntries = ["Hello","Hello2", "World"]
    @State var lastChangeCount: Int = 0
    @State var searchText = ""
    @State var selection: Int? = 0
    let pasteboard: NSPasteboard = .general
    
    var filteredClipboardEntries: [String] {
        clipboardEntries.filter {
            searchText.isEmpty ? true : $0.localizedStandardContains(searchText)
        }
        
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
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
            if selection != nil {
                if nsevent.keyCode == 125 { // arrow down
                    selection = selection! < filteredClipboardEntries.count - 1 ? selection! + 1 : selection!
                } else {
                    if nsevent.keyCode == 126 { // arrow up
                        selection = selection! > 0 ? selection! - 1 : selection!
                    }
                }
            } else {
                selection = 0
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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
