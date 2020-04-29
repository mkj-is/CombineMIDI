import Combine
import Foundation

/// A publisher that emits MIDI messages from a MIDI client when received.
public struct MIDIPublisher: Publisher {
    public typealias Output = MIDIMessage
    public typealias Failure = Never

    private let client: MIDIClient

    init(client: MIDIClient) {
        self.client = client
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = MIDISubscription(client: client, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
