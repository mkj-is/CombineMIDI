import Foundation
import CoreMIDI

@available(macOS 10.15, iOS 13.0, *)
struct MIDIStream {
    private var port = MIDIPortRef()
    
    init(client: MIDIClient, receive: @escaping (MIDIMessage) -> Void) {
        MIDIInputPortCreateWithBlock(client.client, client.generatePortName() as CFString, &port) { pointer, _ in
            pointer
                .unsafeSequence()
                .flatMap { $0.sequence() }
                .chunked(into: 3)
                .compactMap(MIDIMessage.init)
                .forEach(receive)
        }
        for i in 0...MIDIGetNumberOfSources() {
            MIDIPortConnectSource(port, MIDIGetSource(i), nil)
        }
    }
    
    func terminate() {
        MIDIPortDispose(port)
    }
}
