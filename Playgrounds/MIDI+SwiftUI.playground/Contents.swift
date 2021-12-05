import SwiftUI
import CombineMIDI
import PlaygroundSupport

struct MessageDebugView: View {
    @ObservedObject var midi: MIDI

    var body: some View {
        VStack {
            Text("Channel: \(midi.message.channel)")
            Text("Data 1:  \(midi.message.data1)")
            Text("Data 2:  \(midi.message.data2)")
        }
        .font(.system(.headline, design: .monospaced))
    }
}

PlaygroundPage.current.setLiveView(MessageDebugView(midi: MIDI()))
