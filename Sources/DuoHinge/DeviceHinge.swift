#if os(iOS)
import SwiftUI

/// Writes the real hinge angle (iOS 27.1 SDK) into a `SimulatedHinge`, so everything downstream
/// works the same with a drag pad, a slider, or the device. Off-Duo, `context.hinge` is nil and the
/// last angle is left alone.
public struct DeviceHingeObserver: ViewModifier {
    let hinge: SimulatedHinge

    public func body(content: Content) -> some View {
        if #available(iOS 27.1, *) {
            content.onHingeChange { _, context in
                guard let device = context.hinge else { return }
                hinge.angle = device.angle.degrees
            }
        } else {
            content
        }
    }
}

public extension View {
    /// Feed the device hinge angle into `hinge`. Attach once, near the root.
    func deviceHinge(_ hinge: SimulatedHinge) -> some View {
        modifier(DeviceHingeObserver(hinge: hinge))
    }
}
#endif
