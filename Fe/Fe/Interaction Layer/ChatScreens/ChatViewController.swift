//
//  ChatViewController.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-08.
//

import UIKit
//import InputBarAccessoryView
//import FirebaseFirestore
//import FirebaseAuth
//import MessageKit
//import SDWebImage
import Kommunicate

class ChatViewController: UIViewController {
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Basic initialization
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        initAccount()
    }//viewDidLoad
    
    /*--------------------------------------------------------------------
     //MARK: initAccount()
     - Description: Initialize account parameters and application ID
     -------------------------------------------------------------------*/
    func initAccount() {
        let kmUser = KMUser()
        kmUser.userId = Kommunicate.randomId()
        kmUser.displayName = "Fe User"
        kmUser.applicationId = "32910ca4e4b590d1347a448c8d553c94b"
        
        Kommunicate.registerUser(kmUser, completion: { [self]
            response, error in guard error == nil else {return}
            print ("login success")
            startConversation()
        })//registerUser
    }//initAccount
    
    /*--------------------------------------------------------------------
     //MARK: startConversation()
     - Description: Initialize conversation parameters and begin conversation
     -------------------------------------------------------------------*/
    func startConversation() {
        Kommunicate.defaultConfiguration.hideFaqButtonInConversationList = true // Hide from Conversation List screen
        Kommunicate.defaultConfiguration.hideFaqButtonInConversationView = true // Hide from Conversation screen
        Kommunicate.defaultConfiguration.chatBar.optionsToShow = .none
        Kommunicate.defaultConfiguration.hideAudioOptionInChatBar = true
        Kommunicate.createAndShowConversation(from: self) { error in
            guard error == nil else {
                print("Conversation error: \(error.debugDescription)")
                return
            }//guard
            //Success
        }//createAndShowConversation
    }//startConversation
}//chatViewController
