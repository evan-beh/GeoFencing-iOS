# Geofence iOS
This project is a demonstration of geofence with:
1. MKMapView, CustomAnnotation
2. Cocoapod
3. Combine data binding
4. Closure data binding
5. MVVM Design pattern
6. Unit Testing
7. PromiseKit

## FEATURES INCLUDED
1. MKMapView to display user and stations with callout details. And promixity range radius.
2. You can make mock user location using gpx file or using MockLocationService in code.
3. You can make mock user SSID using MockWifiInfoService.
4. User can see if its in geofence area by detecting connection to nearest station wifi or in radius range. The button will change from "PUMP NOW" or "GOTO STATION" as an indicator in range or connected to wifi.
5. XCTest to test user in range of station proximity.
6. Using dependencies injection with protocol to mock location, wifi from existing service class.
7. You can change proximity range in AppConfig.swift -> Constants.radius.
