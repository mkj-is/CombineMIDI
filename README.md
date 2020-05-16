# CombineMIDI

![Build](https://github.com/mkj-is/CombineMIDI/workflows/Build/badge.svg)

Swift package made for easy connection of MIDI controllers to SwiftUI (or UIKit) using Combine.

This package was created as a part of [UIKonf](https://uikonf.com) 2020 talk [**Combine: Connect MIDI signals to SwiftUI**](https://cfp.uikonf.com/proposals/119). It's original aim is no too fully wrap all CoreMIDI features, but to prototype user interface input using MIDI controllers.

## Installation

Add this package to your Xcode project or add following line to your `Package.swift` file:

```swift
.package(url: "https://github.com/mkj-is/CombineMIDI.git", from: "0.1.0")
```

## Features

- Supports macOS 10.15+ and iOS 13.0+.
- Type-safe wrapper for MIDI messages (events).
- Wrapper for the C-style MIDI client in CoreMIDI.
- Combine Publisher for listening to MIDI messages.

## Usage

First you need to create a MIDI client, it should be sufficient to create only one client per app (you can optionally pass name of the client as the initializer parameter):

```
let client = MIDIClient(name: "My app MIDI client")
```

Secondly, you create a publisher and it automatically connects to all sources and listens to all messages.

The first thing you probably want to do is to filter only the messages which are relevant to you.

*Do not forget to receive those events on the main thread when subscribing on the user interface. To prevent dispatching too soon the publisher is emitting on the thread used by CoreMIDI, so you can quickly filter all the messages.*

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
- [ ] All MIDI sources are connected during the first subscription, there currently no way to select particaular device.
- [ ] Sending messages back to other destinations using the client is not possible.

## Contributing

All contributions are welcome.

Project was created by [Matěj Kašpar Jirásek](https://twitter.com/mkj_is).

Project is licensed under [MIT license](LICENSE).
