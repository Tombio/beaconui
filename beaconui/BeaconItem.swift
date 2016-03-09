//
//  BeaconItem.swift
//  beaconui
//
//  Created by Tomi Lahtinen on 09/03/16.
//  Copyright © 2016 Tomi Lahtinen. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct BeaconItem {
    
    let name: String
    let uuid: NSUUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    let image: UIImage

    init(name: String, uuid: NSUUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue, image: String) {
        self.name = name
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
        self.image = UIImage(named: image)!
    }
}

func ==(item: BeaconItem, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.UUIDString == item.uuid.UUIDString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}

func ===(item: BeaconItem, beacon: CLBeaconRegion) -> Bool {
    return ((beacon.proximityUUID.UUIDString == item.uuid.UUIDString)
        && (Int(beacon.major!) == Int(item.majorValue))
        && (Int(beacon.minor!) == Int(item.minorValue)))
}