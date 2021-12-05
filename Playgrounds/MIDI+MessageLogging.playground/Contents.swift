import CombineMIDI
import PlaygroundSupport
import Foundation

let client = MIDIClient()
let cancellable = client.publisher()
    .receive(on: RunLoop.main)
    .sink { message in
        dump(message)
}

PlaygroundPage.current.needsIndefiniteExecution = true
