//
//  HomeScreenLogic.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-17.
//

import Foundation

class HomeScreenLogic {
    
    let HKObj = HKAccessObject()
    let FBObj = FirebaseAccessObject()
    let CDObj = CoreDataAccessObject()
    
    func getLatestInfo() -> String {
        return String(CDObj.fetchLatestHR())
    }
    
}
