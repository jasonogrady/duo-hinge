#if os(iOS)
import SwiftUI

/// Simulated hinge for testers without a Duo: a drag pad (finger speed = hinge speed) plus a slider.
public struct HingePad: View {
    @Bindable var hinge: SimulatedHinge

    public init(hinge: SimulatedHinge) { self.hinge = hinge }

    public var body: some View {
        GroupBox("Simulated hinge") {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.quaternary)
                    .overlay {
                        Text("Drag left–right to fold")
                            .foregroundStyle(.secondary)
                    }
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.tint)
                            .frame(width: 6)
                            .padding(.vertical, 8)
                            .offset(x: hinge.angle / 180 * (geo.size.width - 6))
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0).onChanged { drag in
                            hinge.angle = min(max(drag.location.x / geo.size.width * 180, 0), 180)
                        }
                    )
            }
            .frame(height: 140)
            .accessibilityElement()
            .accessibilityLabel("Hinge drag pad")
            .accessibilityValue("\(Int(hinge.angle)) degrees")
            .accessibilityHint("Drag left to close, right to open. Swipe up or down to adjust.")
            .accessibilityAdjustableAction { direction in
                hinge.angle = min(max(hinge.angle + (direction == .increment ? 15 : -15), 0), 180)
            }

            Slider(value: $hinge.angle, in: 0...180) {
                Text("Hinge angle")
            } minimumValueLabel: {
                Text("0°")
            } maximumValueLabel: {
                Text("180°")
            }
        }
    }
}
#endif
