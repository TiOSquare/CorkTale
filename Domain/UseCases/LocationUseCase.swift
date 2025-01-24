//
//  LocationUseCase.swift
//  App
//
//  Created by 홍기웅 on 1/21/25.
//

import Foundation
import Combine
import CoreLocation
import Shared

public protocol LocationUseCase {
    func startLocationStream() -> AsyncStream<CLLocation>
    func stopLocationStream()
    func startHeadingStream() -> AsyncStream<CLHeading>
    func stopHeadingStream()
}

public class LocationUseCaseImpl:NSObject, LocationUseCase {
    
    private let locationManager = CLLocationManager()
    private let logger = Log.make(with: .domain)
    
    private var addToLocationStream: ((CLLocation) -> Void)?
    private var addToHeadingStream: ((CLHeading) -> Void)?
    
    private lazy var locationStream: AsyncStream<CLLocation> = {
        AsyncStream { [weak self] continuation in
            self?.addToLocationStream = { location in
                continuation.yield(location)
            }
        }
    }()
    
    private lazy var headingStream: AsyncStream<CLHeading> = {
        AsyncStream { [weak self] continuation in
            self?.addToHeadingStream = { heading in
                continuation.yield(heading)
            }
        }
    }()
    
    public override init () {
        super.init()
        
        locationManager.delegate = self
    }
    
    public func startLocationStream() -> AsyncStream<CLLocation> {
        locationManager.startUpdatingLocation()
        return locationStream
    }
    
    public func stopLocationStream() {
        locationManager.stopUpdatingLocation()
    }
    
    public func startHeadingStream() -> AsyncStream<CLHeading> {
        guard CLLocationManager.headingAvailable() else {
            logger.log(level: .error, "not support heading")
            return headingStream
        }
        locationManager.startUpdatingHeading()
        return headingStream
    }
    
    public func stopHeadingStream() {
        locationManager.stopUpdatingHeading()
    }
}

extension LocationUseCaseImpl: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first else {
            logger.log(level: .error, "Failed to get Location")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.addToLocationStream?(currentLocation)
        }
        
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async { [weak self] in
            self?.addToHeadingStream?(newHeading)
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            logger.log("not determined")
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            logger.log("restricted")
            
        case .denied:
            logger.log("denied")
            
        case .authorizedWhenInUse, .authorizedAlways:
            logger.log("authorized")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            
        @unknown default:
            logger.log("unknown default")
            
        }
    }
}
