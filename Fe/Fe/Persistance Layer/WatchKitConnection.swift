//
//  WatchKitConnection.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-04-13.
//

// Imports
import Foundation
import WatchConnectivity

/*------------------------------------------------------------------------
 - Protocol: WatchKitConnectionDelegate : class
 - Description:
 -----------------------------------------------------------------------*/
protocol WatchKitConnectionDelegate: AnyObject {
    func didFinishedActiveSession()
}

/*------------------------------------------------------------------------
 - Protocol: WatchKitConnectionProtocol
 - Description:
 -----------------------------------------------------------------------*/
protocol WatchKitConnectionProtocol {
    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)
}

/*------------------------------------------------------------------------
 - Class: WatchKitConnection : NSObject
 - Description: Holds methods for accessing HealtthKit Data
 -----------------------------------------------------------------------*/
class WatchKitConnection: NSObject {
    static let shared = WatchKitConnection()
    weak var delegate: WatchKitConnectionDelegate?
    //var CDAO : CoreDataAccessObject
//    var moc:NSManagedObjectContext!
//    let appDelegate = UIApplication.shared.delegate as? AppDelegate
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

extension WatchKitConnection: WatchKitConnectionProtocol {
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
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

extension WatchKitConnection: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
        delegate?.didFinishedActiveSession()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage")
        print(message)
        DispatchQueue.main.async {
            guard let heartRate = message.values.first as? String else {
                print("error1")
                return
            }
            CoreDataAccessObject().createHeartRateTableEntry(hrValue: heartRate)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage with reply")
        print(message)
        DispatchQueue.main.async {
            guard let heartRate = message.values.first as? String else {
                print("error1")
                return
            }
            CoreDataAccessObject().createHeartRateTableEntry(hrValue: heartRate)
        }
    }
}
