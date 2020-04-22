import Combine
import CoreMIDI

final class MIDISubscription<S: Subscriber>: Subscription where S.Input == MIDIMessage, S.Failure == Never {
    let combineIdentifier = CombineIdentifier()

    private var subscriber: S?
    private let client: MIDIClient
    private let name: CFString

    private var port = MIDIPortRef()
    private var demand: Subscribers.Demand = .none
    private var portCreated = false

    init(client: MIDIClient, port name: String, subscriber: S) {
        self.client = client
        self.name = name as CFString
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
        MIDIInputPortCreateWithBlock(client.client, name as CFString, &port) { pointer, _ in
            pointer
                .unsafeSequence()
                .flatMap { $0.sequence() }
                .chunked(into: 3)
                .compactMap(MIDIMessage.init)
                .forEach { [weak self] message in
                    guard let self = self else { return }
                    guard self.demand > .none else {
                        self.disposePort()
                        return
                    }

                    self.demand -= .max(1)
                    _ = self.subscriber?.receive(message)   
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
