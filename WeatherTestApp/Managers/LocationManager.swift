//
//  LocationManager.swift
//  WeatherTestApp
//
//  Created by Slava Korolevich on 8.02.23.
//

import CoreLocation

public protocol LocationManager {
    func getUserLocation(complition: @escaping ((CLLocation) -> Void))
    func requestAuthorization(callback: @escaping ((Bool) -> Void))
    func getLocationNameWith(location: CLLocation, completion: @escaping ((String?) -> Void))

    var authorizationStatus: Bool { get }
}

final class LocationManagerImp: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManagerImp()

    private let manager = CLLocationManager()
    private var complition: ((CLLocation) -> Void)?
    private var authorisationCallback: ((Bool) -> Void)?
}

//MARK: - LocationManager
extension LocationManagerImp: LocationManager {

    var authorizationStatus: Bool {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    public func getLocationNameWith(location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }

            var location = ""

            if let name = place.name {
                location.append(name)
            }

            if let country = place.country {
                location.append(", \(country)")
            }

            if let administrativeArea = place.administrativeArea {
                location.append(", \(administrativeArea)")
            }

            completion(location)
        }
    }

    public func getUserLocation(complition: @escaping ((CLLocation) -> Void)) {
        manager.startUpdatingLocation()
        self.complition = complition
    }

    public func requestAuthorization(callback: @escaping ((Bool) -> Void)) {
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        authorisationCallback = callback
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        complition?(location)
        manager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorisationCallback?(authorizationStatus)
    }
}
