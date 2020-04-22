public struct MIDIMessage {
    public enum Status: UInt8, CustomStringConvertible {
        case noteOff = 0x80
        case noteOn = 0x90
        case aftertouch = 0xA0
        case controlChange = 0xB0
        case programChange = 0xC0
        case channelPressure = 0xD0
        case pitchBendChange = 0xE0

        public var description: String {
            switch self {
            case .noteOff:
                return "Note off"
            case .noteOn:
                return "Note on"
            case .aftertouch:
                return "Aftertouch"
            case .controlChange:
                return "Control change"
            case .programChange:
                return "Program change"
            case .channelPressure:
                return "Channel pressure"
            case .pitchBendChange:
                return "Pitch bend change"
            }
        }
    }

    public let status: Status
    public let channel, data1, data2: UInt8

    public static let first: MIDIMessage = MIDIMessage(status: .programChange, channel: 0, data1: 0, data2: 0)

    public init(status: Status = .noteOn, channel: UInt8 = 0, data1: UInt8 = 0, data2: UInt8 = 0) {
        self.status = status
        self.channel = channel
        self.data1 = data1
        self.data2 = data2
    }

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
