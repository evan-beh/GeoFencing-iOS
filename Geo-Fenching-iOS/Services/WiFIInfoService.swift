//
//  WiFIInfoService.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

public protocol WiFIInfoServiceProtocol
{
    func getWiFiSsid() -> String?

}

class WiFIInfoService: WiFIInfoServiceProtocol {
   
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
}

class MockWifiInfoService: WiFIInfoServiceProtocol {
   
    func getWiFiSsid() -> String? {
        return "123456"
    }
    
}

