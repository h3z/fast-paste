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
    let pasteboard: NSPasteboard = .general
    
    var body: some View {
        VStack{
            List(clipboardEntries, id: \.self) { entry in
                Text(entry)
            }
            .padding()
            .onAppear{
                startTimer()
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
