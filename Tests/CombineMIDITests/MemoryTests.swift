import XCTest
import Combine
@testable import CombineMIDI

final class MemoryTests: XCTestCase {
    func testObservableObjectRelease() {
        var midi: MIDI? = MIDI()
        weak var weakMidi = midi
        midi = nil
        XCTAssertNil(weakMidi)
    }

    func testClientRelease() {
        var client: MIDIClient? = MIDIClient()
        weak var weakClient = client

        var publisher: MIDIPublisher? = client?.publisher()
        XCTAssertNotNil(publisher)

        var cancellable: Cancellable? = publisher?.sink { _ in }

        client = nil
        publisher = nil
        XCTAssertNotNil(cancellable)
        XCTAssertNotNil(weakClient)

        cancellable = nil
        XCTAssertNil(weakClient)
    }
}
