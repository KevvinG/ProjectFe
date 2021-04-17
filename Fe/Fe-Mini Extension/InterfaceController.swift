//
//  InterfaceController.swift
//  Fe-Mini Extension
//
//  Created by Kevin Grzela on 2021-02-24.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, WCSessionDelegate {
    
   
    @IBOutlet var startStopButton: WKInterfaceButton!
    @IBOutlet var deviceLabel: WKInterfaceLabel!
    @IBOutlet var bpmLabel: WKInterfaceLabel!
    
    // Our workout session
    var session: HKWorkoutSession!
    // Live workout builder
    var builder: HKLiveWorkoutBuilder!
    // Tracking our workout state
    var workingOut = false
    // Access point for all data managed by HealthKit.
    let healthStore = HKHealthStore()
    var timerRunning : Bool = true
    
    @IBAction func startStopTapped() {
        if !workingOut {
            startWorkout()
            workingOut = true
            startStopButton!.setTitle("Stop")
            deviceLabel!.setText(builder!.device!.name)
        } else {
            stopWorkout()
            workingOut = false
            bpmLabel!.setText("---")
            startStopButton!.setTitle("Start")
            deviceLabel!.setText("Device Info")
        }
    }
    
    override func didAppear() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (succ, error) in
            if !succ {
                fatalError("Error requesting authorization from health store: \(String(describing: error)))")
            }
        }
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
      //  self.timerRunning = true
      //  customTimer()
        
        //_ = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    //@objc func fire()
    func fire()
    {
        print("Fired")
        if !workingOut {
            print("Start WO")
            startWorkout()
            workingOut = true
            startStopButton!.setTitle("Stop")
            deviceLabel!.setText(builder!.device!.name)
        } else {
            print("Stop WO")
            stopWorkout()
            workingOut = false
            bpmLabel!.setText("---")
            startStopButton!.setTitle("Start")
            deviceLabel!.setText("Device Info")
        }
    }
    
    private func customTimer(){
        if (self.timerRunning){
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(9000)) {
                    self.customTimer()
                    print("Timer loop")
                }

                fire()

            }

        }
    
    func initWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .crossTraining
        
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session.associatedWorkoutBuilder()
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        // Setup session and builder.
        session.delegate = self
        builder.delegate = self
        
        /// Set the workout builder's data source.
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
    }
    
    func startWorkout() {
        // Initialize our workout
        initWorkout()
        let o2Unit = HKUnit(from: "%/min")
        let oxySatType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        let oxySatQuantity = HKQuantity(unit: o2Unit, doubleValue: 1)

        // Start the workout session and begin data collection
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (succ, error) in
            if !succ {
                fatalError("Error beginning collection from builder: \(String(describing: error)))")
            }
//            let oxType = HKDiscreteQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!, quantity: o2Unit, start: Date(), end: Date())
//            self.builder.add([oxType]) { (Bool, _: Error?) in
                
//            }
            //let oxySat = HKQuantitySample(type: oxySatType, quantity: oxySatQuantity, start: Date(), end: end)
        }
    }
    
    func stopWorkout() {
        // Stop the workout session
        session.end()
        builder.endCollection(withEnd: Date()) { (success, error) in
            self.builder.finishWorkout { (workout, error) in
                DispatchQueue.main.async() {
                    self.session = nil
                    self.builder = nil
                }
            }
        }
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            switch quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let statistics = workoutBuilder.statistics(for: quantityType)
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics!.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                sendHRMessage(hrVal: value ?? 0.00)
                let stringValue = String(Int(Double(round(1 * value!) / 1)))
                bpmLabel.setText(stringValue)
                print("[workoutBuilder] Heart Rate: \(stringValue)")
                
            case HKQuantityType.quantityType(forIdentifier: .oxygenSaturation):
                let statistics = workoutBuilder.statistics(for: quantityType)
                let oSatUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics!.mostRecentQuantity()?.doubleValue(for: oSatUnit)
                let stringValue = String(Int(Double(round(1 * value!) / 1)))
                //bpmLabel.setText(stringValue)
                print("[workoutBuilder] Oxygen Saturation: \(stringValue)")
            default:
                return
            }
        }
    }
    
    func sendHRMessage(hrVal: Double) {
        if (WCSession.default.isReachable) {
            let message = String(hrVal)
            WCSession.default.sendMessage(["heartRate": message], replyHandler: nil)
            print("message sent \(message)")
        } else {
            print("message failed")
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Retreive the workout event.
        guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
        print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("[workoutSession] Changed State: \(toState.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

//    func sessionDidBecomeInactive(_ session: WCSession) {
//
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//
//    }
}
