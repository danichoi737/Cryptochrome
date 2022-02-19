//
//  MotionView.swift
//  Cryptochrome
//
//  Created by Hyunwook CHOI on 2022/02/17.
//

import SwiftUI

struct MotionView: View {
    @StateObject var detector = MotionDetector(updateInterval: 0.01).started()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Roll:")
                }
                HStack {
                    Text("Pitch:")
                }
                HStack {
                    Text("Yaw:")
                }
                HStack {
                    Text("X-Acc:")
                }
                HStack {
                    Text("Y-Acc:")
                }
                HStack {
                    Text("Z-Acc:")
                }
            }

            VStack(alignment: .center) {
                Text("\(detector.roll.describeMotionAsFixedLengthString())")
                Text("\(detector.pitch.describeMotionAsFixedLengthString())")
                Text("\(detector.yaw.describeMotionAsFixedLengthString())")
                Text("\(detector.xAcceleration.describeMotionAsFixedLengthString())")
                Text("\(detector.yAcceleration.describeMotionAsFixedLengthString())")
                Text("\(detector.zAcceleration.describeMotionAsFixedLengthString())")
            }
            .font(.system(.body, design: .monospaced))
            .environmentObject(detector)
        }
    }
}

struct MotionView_Previews: PreviewProvider {
    @StateObject static var detector = MotionDetector(updateInterval: 0.01).started()

    static var previews: some View {
        MotionView()
            .environmentObject(detector)
    }
}
