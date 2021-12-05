import CombineMIDI

extension MIDIMessage.Status: CustomStringConvertible {
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

