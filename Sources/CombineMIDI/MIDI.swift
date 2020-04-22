
import SwiftUI
import Combine

public final class MIDI: ObservableObject {
    @Published public private(set) var message: MIDIMessage = .first

    private var cancellable: Cancellable?

    public init(client: MIDIClient = MIDIClient()) {
        self.cancellable = MIDIPublisher(client: client)
            .receive(on: RunLoop.main)
            .assign(to: \.message, on: self)
    }
}
