//
//  MapView.swift
//  Cryptochrome
//
//  Created by Hyunwook CHOI on 2022/02/17.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            .accentColor(Color(.systemPink))
            .ignoresSafeArea(edges: .top)
            .onAppear {
                locationManager.checkLocationServicesEnabled()
        }
    }
}

enum LocationDefault {
    static let coordinate = CLLocationCoordinate2D(latitude: 37.167862, longitude: 127.102742)
    static let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: LocationDefault.coordinate, span: LocationDefault.span)
    var locationManager: CLLocationManager?

    func checkLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("LocationServices disabled")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("LocationServices restricted")
            case .denied:
                print("LocationServices denied")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(
                    center: locationManager.location!.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            @unknown default:
                break
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}