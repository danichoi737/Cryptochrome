//
//  MotionDetector.swift
//  Cryptochrome
//
//  Created by Hyunwook CHOI on 2022/02/19.
//

import CoreMotion
import UIKit

class MotionDetector: ObservableObject {
    private let motionManager = CMMotionManager()

    private var timer = Timer()
    private var updateInterval: TimeInterval

    @Published var roll: Double = 0
    @Published var pitch: Double = 0
    @Published var yaw: Double = 0
    @Published var xAcceleration: Double = 0
    @Published var yAcceleration: Double = 0
    @Published var zAcceleration: Double = 0

    // Store motion data
    var onUpdate: (() -> Void) = {}

    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol? = nil
    let orientationNotification = UIDevice.orientationDidChangeNotification

    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }

    func start() {
        // Enable the device's accelerometer hardware and begins the delivery of acceleration events to the receiver
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        orientationObserver = NotificationCenter.default.addObserver(forName: orientationNotification, object: nil, queue: .main) { [weak self] _ in
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .unknown:
                break
            default:
                self?.currentOrientation = UIDevice.current.orientation
            }
        }

        if motionManager.isDeviceMotionAvailable {
            // Start updating motion data
            motionManager.startDeviceMotionUpdates()
            // Create a new timer and schedules it to run
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("Device motion not available.")
        }
    }

    func updateMotionData() {
        // If the motion data exists, it's assigned to 'data' and the code inside the braces runs
        if let data = motionManager.deviceMotion {
            (roll, pitch, yaw) = currentOrientation.adjustedRollPitchYaw(data.attitude)

            xAcceleration = data.userAcceleration.x
            yAcceleration = data.userAcceleration.y
            zAcceleration = data.userAcceleration.z

            onUpdate()
        }
    }

    func stop() {
        // Stop updating
        motionManager.stopDeviceMotionUpdates()
        // Stop the timer
        timer.invalidate()
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver, name: orientationNotification, object: nil)
        }
        orientationObserver = nil
    }

    deinit {
        stop()
    }
}

extension MotionDetector {
    func started() -> MotionDetector {
        start()
        return self
    }
}

extension UIDeviceOrientation {
    func adjustedRollPitchYaw(_ attitude: CMAttitude) -> (roll: Double, pitch: Double, yaw: Double) {
        switch self {
        case .unknown, .faceUp, .faceDown:
            return (attitude.roll, -attitude.pitch, attitude.yaw)
        case .landscapeLeft:
            return (attitude.pitch, -attitude.roll, attitude.yaw)
        case .portrait:
            return (attitude.roll, attitude.pitch, attitude.yaw)
        case .portraitUpsideDown:
            return (-attitude.roll, -attitude.pitch, attitude.yaw)
        case .landscapeRight:
            return (-attitude.pitch, attitude.roll, attitude.yaw)
        @unknown default:
            return (attitude.roll, attitude.pitch, attitude.yaw)
        }
    }
}

extension Double {
    func describeMotionAsFixedLengthString(integerDigits: Int = 2, fractionDigits: Int = 3) -> String {
        self.formatted(
            .number
                .sign(strategy: .always())
                .precision(
                    .integerAndFractionLength(integer: integerDigits, fraction: fractionDigits)
                )
        )
    }
}
