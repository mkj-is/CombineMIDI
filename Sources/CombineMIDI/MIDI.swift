import SwiftUI
import Combine

/// MIDI observable object updating every time new MIDI message
/// is received.
public final class MIDI: ObservableObject {
    @Published public private(set) var message: MIDIMessage = .allNotesOff

    private var cancellable: Cancellable?

    /// Initializes a new MIDI observable object for a supplied client.
    /// - Parameter client: Client which will be used for listening
    ///   to MIDI messages. By default a new client with default name
    ///   will be created.
    public init(client: MIDIClient = MIDIClient()) {
        self.cancellable = client
            .publisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.message = message
            }
    }
}
