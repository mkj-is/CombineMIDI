import Combine
import Foundation

public struct MIDIPublisher: Publisher {
    public typealias Output = MIDIMessage
    public typealias Failure = Never

    private let client: MIDIClient

    init(client: MIDIClient) {
        self.client = client
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = MIDISubscription(client: client, port: UUID().uuidString, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
