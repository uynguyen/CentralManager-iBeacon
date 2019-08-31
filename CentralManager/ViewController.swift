//
//  ViewController.swift
//  CentralManager
//
//  Created by Uy Nguyen Long on 1/5/18.
//  Copyright © 2018 Uy Nguyen Long. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "086704EE-9611-4ACC-91DB-F983ABAC9153")!,
                                      major: 1,
                                      minor: 0,
                                      identifier: "uynguyen")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        startMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startMonitoring() {
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update location")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("did start monitoring \(region.identifier)")
        self.locationManager.requestState(for: self.beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            self.locationManager.startRangingBeacons(in: self.beaconRegion)
        } else {
            self.locationManager.stopRangingBeacons(in: self.beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            NotificationHandler.shared.showNotification(title: "did range region \(beacon.proximity.rawValue)", body: "")
        }

    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("did monitoring failed \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter region")
        NotificationHandler.shared.showNotification(title: "did enter region", body: "")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("did exit region")
    }
}
