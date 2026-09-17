import Testing
import Foundation
@testable import DuoHinge

@Test func statusThresholds() {
    #expect(HingeStatus(angle: 0) == .closed)
    #expect(HingeStatus(angle: 9.9) == .closed)
    #expect(HingeStatus(angle: 90) == .partiallyOpen)
    #expect(HingeStatus(angle: 170.1) == .fullyOpen)
}

@Test func velocityFromSamples() {
    var v = VelocityEstimator()
    let t0 = Date()
    #expect(v.update(angle: 0, at: t0) == 0)
    #expect(v.update(angle: 90, at: t0 + 0.5) == 180)
    #expect(v.update(angle: 45, at: t0 + 1.0) == -90)
    #expect(v.update(angle: 45, at: t0 + 1.0) == 0)   // same timestamp: no divide by zero
}

@Test func simulatedHingeTracksVelocity() {
    let h = SimulatedHinge()
    h.angle = 30
    #expect(h.velocity.isFinite)
    #expect(h.status == .partiallyOpen)
}
