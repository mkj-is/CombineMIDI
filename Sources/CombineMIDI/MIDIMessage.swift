/// Typed MIDI message interpretation.
public struct MIDIMessage {
    /// Kind of the message.
    public enum Status: UInt8 {
        /// Note Off event.
        /// This message is sent when a note is released (ended).
        case noteOff = 0x80

        /// Note On event.
        /// This message is sent when a note is depressed (start).
        case noteOn = 0x90

        /// Polyphonic Key Pressure (Aftertouch).
        /// This message is most often sent by pressing down on
        /// the key after it "bottoms out".
        case aftertouch = 0xA0

        /// Control Change. This message is sent when a controller
        /// value changes. Controllers include devices such as
        /// pedals and levers.
        case controlChange = 0xB0

        /// Program Change. This message sent when the patch
        /// number changes.
        case programChange = 0xC0

        /// Channel Pressure (After-touch).
        /// This message is most often sent by pressing down on
        /// the key after it "bottoms out". This message is
        /// different from polyphonic after-touch. Use this
        /// message to send the single greatest pressure value
        /// (of all the current depressed keys).
        case channelPressure = 0xD0

        /// Pitch Bend Change. This message is sent to indicate
        /// a change in the pitch bender (wheel or lever, typically).
        /// The pitch bender is measured by a fourteen bit value.
        case pitchBendChange = 0xE0
    }

    /// Kind of the message.
    public let status: Status
    /// Channel of the message. Between 0-15.
    public let channel: UInt8
    /// First data byte. Usually a key number (note or controller). Between 0-127.
    public let data1: UInt8
    /// Second data byte. Usually a value (pressure, velocity or program number). Between 0-127.
    public let data2: UInt8

    /// All Notes Off. When an All Notes Off is received, all oscillators will turn off.
    public static let allNotesOff: MIDIMessage = MIDIMessage(status: .controlChange, channel: 0, data1: 123, data2: 0)

    /// Initializes new message manually with all the parameters.
    /// - Parameters:
    ///   - status: Kind of the message.
    ///   - channel: Channel of the message. Between 0-15.
    ///   - data1: First data byte. Usually a key number (note or controller). Between 0-127.
    ///   - data2: Second data bytes. Usually a value (pressure, velocity or program number). Between 0-127.
    public init(status: Status = .noteOn, channel: UInt8 = 0, data1: UInt8 = 0, data2: UInt8 = 0) {
        self.status = status
        self.channel = channel
        self.data1 = data1
        self.data2 = data2
    }

    /// Initializes new message automatically by parsing an array of bytes (usually from a MIDI packet).
    /// - Parameters:
    ///   - bytes: Array of bytes. At least three bytes must be supplied to create strongly-typed
    ///   MIDI message.
    public init?(bytes: [UInt8]) {
        guard bytes.count >= 3, let status = Status(rawValue: bytes[0] & 0xF0) else {
            return nil
        }
        self.status = status
        self.channel = bytes[0] & 0x0F
        self.data1 = bytes[1]
        self.data2 = bytes[2]
    }
}
