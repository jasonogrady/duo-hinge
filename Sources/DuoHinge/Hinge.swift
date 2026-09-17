import Foundation
import Observation

public enum HingeStatus: String, Sendable {
    case closed, partiallyOpen = "partially open", fullyOpen = "fully open"

    public init(angle: Double) {
        self = angle < 10 ? .closed : angle > 170 ? .fullyOpen : .partiallyOpen
    }
}

/// Where the hinge angle comes from. `SimulatedHinge` is the one implementation;
/// on an iPhone Duo, `.deviceHinge(_:)` feeds it the real angle.
public protocol HingeSource: AnyObject, Observable {
    /// Degrees, 0 (closed) ... 180 (flat open).
    var angle: Double { get }
    /// Degrees per second from the last two samples; positive = opening. Holds its last value when samples stop.
    var velocity: Double { get }
}

public extension HingeSource {
    var status: HingeStatus { HingeStatus(angle: angle) }
}

/// Velocity from consecutive angle samples.
public struct VelocityEstimator: Sendable {
    private var last: (angle: Double, time: Date)?

    public init() {}

    public mutating func update(angle: Double, at now: Date = .now) -> Double {
        defer { last = (angle, now) }
        guard let last, now > last.time else { return 0 }
        return (angle - last.angle) / now.timeIntervalSince(last.time)
    }
}

/// A hinge you can drive from anywhere: a slider, `HingePad`, a test, or the real device via `.deviceHinge(_:)`.
@Observable public final class SimulatedHinge: HingeSource {
    public var angle: Double = 0 {
        didSet { velocity = estimator.update(angle: angle) }
    }
    public private(set) var velocity: Double = 0
    @ObservationIgnored private var estimator = VelocityEstimator()

    public init(angle: Double = 0) { self.angle = angle }
}
