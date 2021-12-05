import CoreMIDI

/// Object holding a reference to a low-level CoreMIDI client
/// when it is in memory.
public final class MIDIClient {
    private(set) var client = MIDIClientRef()
    private let name: String

    /// Initializes the client with a supplied name.
    /// - Parameter name: Name of the client, "Combine Client" by default.
    public init(name: String = "Combine Client") {
        self.name = name
        MIDIClientCreate(name as CFString, nil, nil, &client)
    }

    deinit {
        MIDIClientDispose(client)
    }

    /// Returns new MIDI message publisher for this client.
    public func publisher() -> MIDIPublisher {
        MIDIPublisher(client: self)
    }
    
    #if swift(>=5.5.2)
    @available(macOS 10.15, iOS 13.0, *)
    public var stream: AsyncStream<MIDIMessage> {
        AsyncStream { continuation in
            let stream = MIDIStream(client: self) { message in
                continuation.yield(message)
            }
            continuation.onTermination = { @Sendable _ in
                stream.terminate()
            }
        }
    }
    #endif

    func generatePortName() -> String {
        "\(name)-\(UUID().uuidString)"
    }
}
