import Combine
import CoreMIDI

final class MIDISubscription<S: Subscriber>: Subscription where S.Input == MIDIMessage, S.Failure == Never {
    let combineIdentifier = CombineIdentifier()

    private var subscriber: S?
    private let client: MIDIClient

    private var port = MIDIPortRef()
    private var demand: Subscribers.Demand = .none
    private var portCreated = false

    init(client: MIDIClient, subscriber: S) {
        self.client = client
        self.subscriber = subscriber
    }

    func request(_ newDemand: Subscribers.Demand) {
        guard newDemand > .none else {
            return
        }
        demand += newDemand
        guard portCreated else {
            createPort()
            return
        }
    }

    func cancel() {
        disposePort()
        subscriber = nil
    }

    private func createPort() {
        MIDIInputPortCreateWithBlock(client.client, client.generatePortName() as CFString, &port) { pointer, _ in
            pointer
                .unsafeSequence()
                .flatMap { $0.sequence() }
                .reduce(into: ([MIDIMessage](), Optional<MIDIMessage.PartialMessage>.none)) { (messageStream, nextByte) in
                    if messageStream.1 == nil {
                        // No partial message
                        switch MIDIMessage.from(byte: nextByte) {
                        case .partial(let partial):
                            messageStream.1 = partial
                        case .message(let message):
                            messageStream.0.append(message)
                        }
                    } else {
                        let message = messageStream.1!.appending(byte: nextByte)
                        if let message = message {
                            messageStream.0.append(message)
                            messageStream.1 = nil
                        }
                    }
                }.0
                .forEach { [weak self] message in
                    guard let self = self, let subscriber = self.subscriber else { return }
                    guard self.demand > .none else {
                        self.disposePort()
                        return
                    }

                    self.demand -= .max(1)
                    _ = subscriber.receive(message)
                }
        }
        for i in 0...MIDIGetNumberOfSources() {
            MIDIPortConnectSource(port, MIDIGetSource(i), nil)
        }
        portCreated = true
    }

    private func disposePort() {
        MIDIPortDispose(port)
        portCreated = false
    }
}
