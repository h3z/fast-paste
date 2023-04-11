//
//  ContentView.swift
//  fast paste
//
//  Created by hzzz on 2023/4/11.
//

import SwiftUI

struct ContentView: View {
    @State var clipboardEntries = ["Hello", "World"]
    @State var lastChangeCount: Int = 0
    @State var searchText = ""
    @State var selection: Int?
    @State var selectedEntry: String? = "Hello"
    
    let pasteboard: NSPasteboard = .general
    
    var filteredClipboardEntries: [String] {
        clipboardEntries.filter { searchText.isEmpty ? true : $0.localizedStandardContains(searchText) }
    }
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            Divider()
            List(selection: $selection) {
                ForEach(clipboardEntries.indices, id: \.self) { index in
                    Text(clipboardEntries[index]).tag(index)
                }
            }
            .padding()
            .onAppear {
                startTimer()
                
                NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { nsevent in
                    print(nsevent.keyCode)
                    if selection != nil {
                        if nsevent.keyCode == 125 { // arrow down
                            selection = selection! < clipboardEntries.count ? selection! + 1 : 0
                        } else {
                            if nsevent.keyCode == 126 { // arrow up
                                selection = selection! > 1 ? selection! - 1 : 0
                            }
                        }
                    } else {
                        selection = 0
                    }
                    return nsevent
                }
                
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didHideNotification)) { _ in
                searchText = ""
            }
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
