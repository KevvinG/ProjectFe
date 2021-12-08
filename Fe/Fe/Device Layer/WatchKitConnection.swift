//
//  WatchKitConnection.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-13.
//

//MARK: Imports
import Foundation
import WatchConnectivity

/*------------------------------------------------------------------------
 //MARK: WatchKitConnectionDelegate : class
 - Description: Connection for Apple Watch
 -----------------------------------------------------------------------*/
protocol WatchKitConnectionDelegate: AnyObject {
    func didFinishedActiveSession()
}

/*------------------------------------------------------------------------
 //MARK: WatchKitConnectionProtocol
 - Description:
 -----------------------------------------------------------------------*/
protocol WatchKitConnectionProtocol {
    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)
}

/*------------------------------------------------------------------------
 //MARK: WatchKitConnection : NSObject
 - Description: Holds methods for accessing HealtthKit Data
 -----------------------------------------------------------------------*/
class WatchKitConnection: NSObject {
    
    // Class Variables
    static let shared = WatchKitConnection()
    weak var delegate: WatchKitConnectionDelegate?
    //var CDAO : CoreDataAccessObject
//    var moc:NSManagedObjectContext!
//    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    /*--------------------------------------------------------------------
     //MARK: init()
     - Description: Code initialization
     -------------------------------------------------------------------*/
    private override init() {
        super.init()
//        moc = appDelegate?.persistentContainer.viewContext
        //self.CDAO = CoreDataAccessObject()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
#if os(iOS)
        if let session = session, session.isPaired, session.isWatchAppInstalled {
            return session
        }
#elseif os(watchOS)
            return session
#endif
        return nil
    }
    
    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }
}

/*------------------------------------------------------------------------
 //MARK: WatchKitConnection : WatchKitConnectionProtocol
 - Description:
 -----------------------------------------------------------------------*/
extension WatchKitConnection: WatchKitConnectionProtocol {
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    /*--------------------------------------------------------------------
     //MARK: sendMessage()
     - Description: Sends message from watch to phone app.
     -------------------------------------------------------------------*/
    func sendMessage(message: [String : AnyObject],
                     replyHandler: (([String : AnyObject]) -> Void)? = nil,
                     errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessage(message, replyHandler: { (result) in
            print(result)
        }, errorHandler: { (error) in
            print(error)
        })
    }
}

/*------------------------------------------------------------------------
 //MARK: WatchKitConnection: WCSessionDelegate
 - Description:
 -----------------------------------------------------------------------*/
extension WatchKitConnection: WCSessionDelegate {
    
    /*--------------------------------------------------------------------
     //MARK: session()
     - Description:
     -------------------------------------------------------------------*/
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //print("activationDidCompleteWith")
        delegate?.didFinishedActiveSession()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let heartRate = message.values.first as? String else {
                print("Error in WatchKit Connection Session function 1.")
                return
            }
            CoreDataAccessObject().createHeartRateTableEntry(hrValue: heartRate)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            guard let heartRate = message.values.first as? String else {
                print("Error in WatchKit Connection Session function 2.")
                return
            }
            CoreDataAccessObject().createHeartRateTableEntry(hrValue: heartRate)
        }
    }
}
