//
//  ChatViewController.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-08.
//

//MARK: Imports
import UIKit
import Kommunicate

/*------------------------------------------------------------------------
 //MARK: ChatViewController: UIViewController
 - Description: Holds UI initializers for chatbot on screen.
 -----------------------------------------------------------------------*/
class ChatViewController: UIViewController {
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Basic initialization
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        initAccount()
    }
    
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
        })
    }
    
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
            }
        }
    }
}
