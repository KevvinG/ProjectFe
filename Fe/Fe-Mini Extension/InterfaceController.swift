//
//  InterfaceController.swift
//  Fe-Mini Extension
//
//  Created by Kevin Grzela on 2021-02-24.
//

//MARK: Imports
import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

/*------------------------------------------------------------------------
 //MARK: InterfaceControlleer : WKInterfaceController, HKWorkoutSessionDelegate,
 HKLiveWorkoutBuilderDelegate, WCSessionDelegate
 - Description: Holds logic for interface of Apple Watch
 -----------------------------------------------------------------------*/
class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, WCSessionDelegate {
    
    // UI Variables
    @IBOutlet var startStopButton: WKInterfaceButton!
    @IBOutlet var bpmLabel: WKInterfaceLabel!
    @IBOutlet var bldOxLabel: WKInterfaceLabel!
    
    // Class Variables
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    var workingOut = false
    let healthStore = HKHealthStore()
    
    /*--------------------------------------------------------------------
     //MARK: didAppear()
     - Description: Initialize variables when screen loads.
     -------------------------------------------------------------------*/
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
    }
    
    /*--------------------------------------------------------------------
     //MARK: startStopTapped()
     - Description: Tap the Start/Stop button on screen.
     -------------------------------------------------------------------*/
    @IBAction func startStopTapped() {
        if !workingOut {
            startWorkout()
            workingOut = true
            startStopButton!.setTitle("Stop")
        } else {
            stopWorkout()
            workingOut = false
            startStopButton!.setTitle("Start")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: startWorkout()
     - Description: Start the workout.
     -------------------------------------------------------------------*/
    func startWorkout() {
        initWorkout()
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (succ, error) in
            if !succ {
                fatalError("Error beginning collection from builder: \(String(describing: error)))")
            }
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: stopWorkout()
     - Description: Stop the workout.
     -------------------------------------------------------------------*/
    func stopWorkout() {
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
    
    /*--------------------------------------------------------------------
     //MARK: initWorkout()
     - Description: Initializes the Workout Configuration.
     -------------------------------------------------------------------*/
    func initWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session.associatedWorkoutBuilder()
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        // Set the workout builder's data source.
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        
        // Setup session and builder.
        session.delegate = self
        builder.delegate = self
    }
    
    /*--------------------------------------------------------------------
     //MARK: workoutBuilder()
     - Description: Collects sample types and sends messages.
     -------------------------------------------------------------------*/
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            
            switch quantityType {
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let statistics = workoutBuilder.statistics(for: quantityType)
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    var value = statistics!.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                    
                    // Generate random value to trip thresholds
                    let randomInt = Int.random(in: 1..<100)
                    if randomInt < 10 {
                        value = 32
                    }
                    if randomInt > 90 {
                        value = 152
                    }
                    // end of random
                    
                    sendHRMessage(hrVal: value ?? 0.00)
                    let stringValue = String(Int(Double(round(1 * value!) / 1)))
                    bpmLabel.setText("HR: \(stringValue) BPM")
                    print("[workoutBuilder] Heart Rate: \(stringValue)")
                    break

                case HKQuantityType.quantityType(forIdentifier: .oxygenSaturation):
                    let statistics = workoutBuilder.statistics(for: quantityType)
                    let oSatUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let value = statistics!.mostRecentQuantity()?.doubleValue(for: oSatUnit)
                    sendBloodOxMessage(bloodOx: value ?? 0.00)
                    let stringValue = String(Int(Double(round(1 * value!) / 1)))
                    bldOxLabel.setText("Blood Ox: \(stringValue) %")
                    print("[workoutBuilder] Blood Oxygen: \(stringValue)")
                    break
                    
                default:
                    return
            }
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: sendHRMessage()
     - Description: Sends message for Heart Rate
     -------------------------------------------------------------------*/
    func sendHRMessage(hrVal: Double) {
        if (WCSession.default.isReachable) {
            let message = String(hrVal)
            WCSession.default.sendMessage(["heartRate": message], replyHandler: nil)
            print("HR message sent \(message)")
        } else {
            print("HR message failed")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: sendBloodOxMessage()
     - Description: Sends message for Blood Oxygen.
     -------------------------------------------------------------------*/
    func sendBloodOxMessage(bloodOx: Double) {
        if (WCSession.default.isReachable) {
            let message = String(bloodOx)
            WCSession.default.sendMessage(["bloodOxygen": message], replyHandler: nil)
            print("BldOx message sent \(message)")
        } else {
            print("BldOx message failed")
        }
    }
    
    /*--------------------------------------------------------------------
     //MARK: workoutBuilderDidCollectEvent()
     - Description: Retreive the workout event.
     -------------------------------------------------------------------*/
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
        print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
    }
    
    /*--------------------------------------------------------------------
     //MARK: workoutSession()
     - Description: Note when state is changed.
     -------------------------------------------------------------------*/
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("[workoutSession] Changed State: \(toState.rawValue)")
    }
    
    /*--------------------------------------------------------------------
     //MARK: workoutSession()
     - Description: Note if there was an error.
     -------------------------------------------------------------------*/
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
    
    /*--------------------------------------------------------------------
     //MARK: session()
     - Description: Note session error.
     -------------------------------------------------------------------*/
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session error: \(String(describing: error))")
    }
}
