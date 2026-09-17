# DuoHinge

One hinge model for iPhone Duo apps, extracted from [Hingy.app](https://hingy.app).

The real hinge API (`onHingeChange`, iOS 27.1+) only fires on a Duo, and as of Xcode 27.2 beta there is no Duo simulator runtime. So your app needs a hinge it can drive from a slider, a drag pad, or a test, and the device should just be one more thing that writes into it. That is all this is.

```swift
import DuoHinge

@State private var hinge = SimulatedHinge()

var body: some View {
    VStack {
        Text("\(Int(hinge.angle))°, \(hinge.status.rawValue)")
        Text("\(Int(hinge.velocity))°/s")
        #if DEBUG
        HingePad(hinge: hinge)   // drag pad + slider for testers without a Duo
        #endif
    }
    .deviceHinge(hinge)          // on a Duo, the real angle lands here
}
```

- `SimulatedHinge`: `@Observable`, `angle` 0...180 degrees, `velocity` in degrees per second (positive = opening) from the last two samples.
- `HingeStatus`: closed under 10°, fully open over 170°, partially open between. Tune to taste.
- `HingePad`: the drag pad and slider. Finger speed becomes hinge speed, so velocity-driven effects are testable without hardware. Accessible via adjustable actions.
- `.deviceHinge(_:)`: attach once near the root. Off-Duo it does nothing.

Requires Xcode 27.1 or later to compile the device observer. Everything else works on iOS 17+.

```swift
.package(url: "https://github.com/jasonogrady/duo-hinge", from: "0.1.0")
```

MIT. Made for [Hingy.app](https://hingy.app), hinge sounds and stats for iPhone Duo.
