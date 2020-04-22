import CoreMIDI

public final class MIDIClient {
    private(set) var client = MIDIClientRef()
    private let name: String

    public init(name: String = "Combine Client") {
        self.name = name
        MIDIClientCreate(name as CFString, nil, nil, &client)
    }

    deinit {
        MIDIClientDispose(client)
    }

    public func publisher() -> MIDIPublisher {
        MIDIPublisher(client: self)
    }

    func generatePortName() -> String {
        "\(name)-\(UUID().uuidString)"
    }
}
