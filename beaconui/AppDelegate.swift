//
//  AppDelegate.swift
//  beaconui
//
//  Created by Tomi Lahtinen on 09/03/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    let items = [
        BeaconItem(name: "mac", uuid: NSUUID(UUIDString: "433C5E28-7E6C-40BE-A169-40ED555A8B74")!, majorValue: 43300, minorValue: 52986, image: "beacon1"),
        BeaconItem(name: "ipad", uuid: NSUUID(UUIDString: "B7D1027D-6788-416E-994F-EA11075F1765")!, majorValue: 43300, minorValue: 52987, image: "beacon2")
    ]
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        initBeacons()
        debugPrint("Beacons inited")
        
        return true
    }
    
    func initBeacons() {
        for item in items {
            let region = beaconRegionWithItem(item)
            locationManager.startMonitoringForRegion(region)
            locationManager.startRangingBeaconsInRegion(region)
            debugPrint("start monitoring location of \(item.name)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        debugPrint("beacon count \(beacons.count)")
        let sorted = beacons.sort { (beacon1, beacon2) -> Bool in
            if beacon2.proximity == CLProximity.Unknown {
                return true
            }
            if beacon1.proximity == CLProximity.Unknown {
                return false
            }
            
            return beacon1.proximity.rawValue < beacon2.proximity.rawValue
        }
        if let beacon = sorted.first {
            debugPrint("beacon major / minor: \(beacon.major) / \(beacon.minor)")
            debugPrint("region major / minor: \(region.major) / \(region.minor)")
            for item in items {
                if item == beacon {
                    setImage(item)
                    return
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        debugPrint("Failed monitoring region: \(error.description)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        debugPrint("Location manager failed: \(error.description)")
    }
    
    func setImage(item: BeaconItem){
        if let vc = self.window?.rootViewController {
            (vc as! ViewController).imageView.image = item.image
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func beaconRegionWithItem(item: BeaconItem) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: item.uuid,
            major: item.majorValue,
            minor: item.minorValue,
            identifier: item.name)
        return beaconRegion
    }
}