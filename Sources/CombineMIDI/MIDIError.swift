/// The error constants unique to Core MIDI.
///
/// These are the error constants that are unique to Core MIDI.
/// Note that Core MIDI functions may return other codes that are not listed here.
public enum MIDIError: Int, Error {
    /// An invalid MIDIClientRef was passed.
    case invalidClient      = -10830
    /// An invalid MIDIPortRef was passed.
    case invalidPort        = -10831
    /// A source endpoint was passed to a function expecting a destination, or vice versa.
    case wrongEndpointType  = -10832
    /// Attempt to close a non-existant connection.
    case noConnection       = -10833
    /// An invalid MIDIEndpointRef was passed.
    case unknownEndpoint    = -10834
    /// Attempt to query a property not set on the object.
    case unknownProperty    = -10835
    /// Attempt to set a property with a value not of the correct type.
    case wrongPropertyType  = -10836
    /// Internal error; there is no current MIDI setup object.
    case noCurrentSetup     = -10837
    /// Communication with MIDIServer failed.
    case messageSend        = -10838
    /// Unable to start MIDIServer.
    case serverStart        = -10839
    /// Unable to read the saved state.
    case setupFormat        = -10840
    /// A driver is calling a non-I/O function in the server from a thread other than
    /// the server's main thread.
    case wrongThread        = -10841
    /// The requested object does not exist.
    case objectNotFound     = -10842
    /// Attempt to set a non-unique kMIDIPropertyUniqueID on an object.
    case idNotUnique        = -10843
    /// The process does not have privileges for the requested operation.
    case notPermitted       = -10844
    /// Internal error; unable to perform the requested operation.
    case unknown            = -10845

    /// Initializes MIDI error with OSStatus error.
    /// If unknown code is provided then `unknown` case is returned.
    init(errorCode: Int) {
        self = MIDIError(rawValue: errorCode) ?? .unknown
    }
}
