//
//  ContentView.swift
//  Cryptochrome
//
//  Created by Hyunwook CHOI on 2022/02/16.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .dashboard
    
    enum Tab {
        case dashboard
        case location
        case motion
    }

    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.3.group")
                }
                .tag(Tab.dashboard)
            
            LocationView()
                .tabItem {
                    Label("Location", systemImage: "location")
                }
                .tag(Tab.location)
            
            MotionView()
                .tabItem {
                    Label("Motion", systemImage: "move.3d")
                }
                .tag(Tab.motion)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
