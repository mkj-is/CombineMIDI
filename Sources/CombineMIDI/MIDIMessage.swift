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
        
        /// Tune request. Tells analog synthesizers to tune.
        case tuneRequest = 0xF6
        
        // System Real-Time Messages
        
        /// Timing Clock. Sent 24 times per quarter note when synchronization
        /// is required.
        case timingClock = 0xF8
        
        /// Start. Message to start the current sequence.
        case start = 0xFA
        
        /// Continue. Continue sequence from last stopped point.
        case `continue` = 0xFB
        
        /// Stop. Stops the current sequence
        case stop = 0xFC
        
        /// Active Sensing. Optional mechanism to keep
        /// connections alive.
        case activeSensing = 0xFE
        
        /// System Reset. Should not be sent on power-up, but
        /// to reset receivers to their power-up status.
        case systemReset = 0xFF
        
        /// Number of bytes expected in a message with this status
        var bytesPerMessage: UInt8 {
            switch self {
            case .noteOff, .noteOn, .aftertouch, .controlChange, .pitchBendChange:
                return 3
            case .programChange, .channelPressure:
                return 2
            case .tuneRequest, .timingClock, .start, .continue, .stop, .activeSensing, .systemReset:
                return 1
            }
        }
        
        var hasChannel: Bool {
            switch self {
            case .noteOff, .noteOn, .aftertouch, .controlChange, .programChange, .channelPressure, .pitchBendChange:
                return true
            case .tuneRequest, .timingClock, .start, .continue, .stop, .activeSensing, .systemReset:
                return false
            }
        }
    }

    /// Kind of the message.
    public let status: Status
    /// Channel of the message. Between 0-15.
    public let channel: UInt8?
    /// First data byte. Usually a key number (note or controller). Between 0-127.
    public let data1: UInt8?
    /// Second data byte. Usually a value (pressure, velocity or program number). Between 0-127.
    public let data2: UInt8?

    /// All Notes Off. When an All Notes Off is received, all oscillators will turn off.
    static let allNotesOff: MIDIMessage = MIDIMessage(status: .controlChange, channel: 0, data1: 123, data2: 0)

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
    ///   - bytes: Array of bytes with at least one byte. Different message types may be 1, 2, or 3 bytes
    ///   as determined by the first 4 bits (status). If the number of bytes does not match the expected number as
    ///   denoted by the status, this will return `nil`.
    public init?(bytes: [UInt8]) {
        guard let statusByte = bytes.first,
              let status = Status(rawValue: statusByte & 0xF0),
              bytes.count == status.bytesPerMessage
        else {
            return nil
        }
        self.status = status
        if status.hasChannel {
            self.channel = bytes[0] & 0x0F
        } else {
            self.channel = nil
        }
        if status.bytesPerMessage > 1 {
            self.data1 = bytes[1]
        } else {
            self.data1 = nil
        }
        if status.bytesPerMessage > 2 {
            self.data2 = bytes[2]
        } else {
            self.data2 = nil
        }
    }
}

extension MIDIMessage {
    struct PartialMessage {
        var data: [UInt8]
        var status: Status? {
            return Status(rawValue: data[0] & 0xF0)
        }
        var message: MIDIMessage? {
            return MIDIMessage(bytes: data)
        }
        mutating func appending(byte: UInt8) -> MIDIMessage? {
            data.append(byte)
            return message
        }
    }
    enum InstreamMessage {
        case message(MIDIMessage)
        case partial(PartialMessage)
    }
    static func from(byte: UInt8) -> InstreamMessage {
        let partial = PartialMessage(data: [byte])
        if let message = partial.message {
            return .message(message)
        }
        return .partial(partial)
    }
}
