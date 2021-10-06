//
//  AppDelegate.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-10.
//

//MARK: Imports
import UIKit
import CoreData
import Firebase
import GoogleSignIn
import UserNotifications
import BackgroundTasks

// MARK: App Delegate Class
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    //MARK: Application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set Up Background Tasks
//        registerForBackgroundTasks()

        // Configure Firebase
        FirebaseApp.configure()
        WatchKitConnection.shared.startSession()
        
        // Code to allow Push Notifications on device
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        // implement Messaging Delegate Protocol
        Messaging.messaging().delegate = self
        
        return true
    }
    
    //MARK: RegisterForBackgroundTasks
    private func registerForBackgroundTasks() {
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.Fe.medicationReminder", using: nil) { task in
//        self.scheduleMedicationReminder(task: task as! BGProcessingTask)
//        }
    }
    
    //MARK: ScheduleMedicationReminder
    func scheduleMedicationReminder(task: BGProcessingTask) {
//        let request = BGProcessingTaskRequest(identifier: "com.Fe.medicationReminder")
//        request.requiresNetworkConnectivity = false // Doesn't need internet
//        request.requiresExternalPower = false // Doesn't need to be plugged in
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // Start in 1 minute
//
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Could not schedule medication reminder task: \(error)")
//        }
    }
    
    //MARK: AppDidEnterBackground
    func applicationDidEnterBackground(_ application: UIApplication) {
//        scheduleMedicationReminder()
    }
    
    //MARK: CancelPendingBGTasks
    func cancelPendingBGTasks() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    //MARK: Messaging
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Notify if token changes
//        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // Update token
        FirebaseAccessObject().updateUserMessagingToken(fcmToken: fcmToken!)
    }
    
    //MARK: App for Remote Notification
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //MARK: NotifCenter-Present
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                  -> Void) {
        // Receive displayed notifications for iOS 10 devices.
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.alert, .sound]])
    }

    //MARK: NotifCenter-Received
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      print(userInfo)
      completionHandler()
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Fe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
