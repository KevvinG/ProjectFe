//
//  CustomTimer.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-06-04.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: Class CustomTimer
 - Description: Holds logic for the Timer
 -----------------------------------------------------------------------*/
class CustomTimer {
    
    // Class Variables
    typealias Update = (Int)->Void
    var timer:Timer?
    var count: Int = 0
    var update: Update?

    /*--------------------------------------------------------------------
     //MARK: init()
     - Description: Init for Timer.
     -------------------------------------------------------------------*/
    init(update:@escaping Update){
        self.update = update
    }
    
    /*--------------------------------------------------------------------
     //MARK: start()
     - Description: Starts the Timer.
     -------------------------------------------------------------------*/
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    /*--------------------------------------------------------------------
     //MARK: stop()
     - Description: Stops the Timer.
     -------------------------------------------------------------------*/
    func stop(){
        if let timer = timer {
            timer.invalidate()
        }
    }

    /*--------------------------------------------------------------------
     //MARK: timerUpdate()
     - Description: Adds one second to the timer.
     -------------------------------------------------------------------*/
    @objc func timerUpdate() {
        count += 1;
        if let update = update {
            update(count)
        }
    }
}
