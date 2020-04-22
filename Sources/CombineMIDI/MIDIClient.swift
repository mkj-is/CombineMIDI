import CoreMIDI

public final class MIDIClient {
    private(set) var client = MIDIClientRef()

    public init(name: String = "Combine Client") {
        MIDIClientCreate(name as CFString, nil, nil, &client)
    }

    deinit {
        MIDIClientDispose(client)
    }

    public func publisher() -> MIDIPublisher {
        MIDIPublisher(client: self)
    }
}
