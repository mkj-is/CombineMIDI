# CombineMIDI

![Build](https://github.com/mkj-is/CombineMIDI/workflows/Build/badge.svg)

Swift package made for easy connection of MIDI controllers to SwiftUI
(or UIKit) using Combine and async-await.

This package was created as a part of [UIKonf 2020](https://uikonf.com)
talk **Combine: Connect MIDI signals to SwiftUI**.
It's main goal is to read messages from all MIDI sources
and to be able to present these values in the user interface.

For more guidance, demos and history see materials for the talk:

- [Video](https://youtu.be/2jTtqoYwQF0)
- [Slides](https://speakerdeck.com/mkj/combine-connect-midi-signals-to-swiftui)
- [Proposal](https://cfp.uikonf.com/proposals/119)

## Installation

Add this package to your Xcode project or add following line
to your `Package.swift` file:

```swift
.package(url: "https://github.com/mkj-is/CombineMIDI.git", from: "0.1.0")
```

## Features

- Supports macOS 10.15+ and iOS 13.0+.
- Type-safe wrapper for MIDI messages (events).
- Wrapper for the C-style MIDI client in CoreMIDI.
- Combine Publisher for listening to MIDI messages.
- MIDI AsyncStream for processing MIDI messages.

## Usage

First you need to create a MIDI client, it should be sufficient to create
only one client per app
(you can optionally pass name of the client as the initializer parameter):

```swift
let client = MIDIClient(name: "My app MIDI client")
```

### Async-await

The first thing you probably want to do is to filter the messages
which are relevant to you and get the values.

```swift
let stream = client.stream
    .filter { $0.status == .controlChange }
    .map(\.data2)
```

The you can process messages in a simple for-loop.
*The loop will be running indefinitely until the task
enclosing it will be cancelled.*

```
for await message in stream {
    ...
}
```

### Combine

When using Combine, you create a publisher and it automatically connects
to all sources and listens to all messages on subscribtion.

*Do not forget to receive those events on the main thread when subscribing
on the user interface. To prevent dispatching too soon the publisher is
emitting on the thread used by CoreMIDI, so you can quickly filter all
the messages.*

```swift
cancellable = client
    .publisher()
    .filter { $0.status == .controlChange }
    .map { $0.data2 }
    .receive(on: RunLoop.main)
    .sink { value in
        ...
    }
```

## Next steps

This library is small on purpose and there is a large potential for improvement:

- [ ] New MIDI controllers are not detected when the subscription was already made.
- [ ] All MIDI sources are connected during the first subscription,
      there is currently no way to select a particular device.
- [ ] Sending messages back to other destinations using the client is not possible.

## Contributing

All contributions are welcome.

Project was created by [Matěj Kašpar Jirásek](https://twitter.com/mkj_is).

Project is licensed under [MIT license](LICENSE).
