//
//  Geo_Fenching_iOSTests.swift
//  Geo-Fenching-iOSTests
//
//  Created by Evan Beh on 06/08/2021.
//

import XCTest
import PromiseKit

@testable import Geo_Fenching_iOS

class Geo_Fenching_iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInRangeAndConnectWifi() throws {
       
        // This is a function to test user connected in range and wifi connected.
        //TODO : goto MockWifiInfoService to change wifi ID which is different from StationService
        //TODO : goto MockLocationService to change current user location for simulation
        
        let viewModel = ViewModel(locationService: MockLocationService(), stationService: StationService(), wifiService: MockWifiInfoService (), userInfoServices: UserInfoServices())
        
        
        
        firstly {
            viewModel.retreivePageData()
        }.ensure {
            viewModel.getNearestStation()
        }.ensure {
            
            if let station = viewModel.nearestStation,let user = viewModel.userInfoObject
            {
                viewModel.validateInRangeAndConnectWifi(station: station, user: user as! UserObjectModel)

            }
        }.catch { error in
            print(error.localizedDescription)
        }.finally {

            print (viewModel.enablePump)
            XCTAssertTrue( viewModel.enablePump )

        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
