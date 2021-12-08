//
//  Chat.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-09.
//

//MARK: Imports
import Foundation

/*------------------------------------------------------------------------
 //MARK: struct Chat
 - Description: Holds logic for the chatbot
 -----------------------------------------------------------------------*/
struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
    return ["users": users]
   }
}

/*------------------------------------------------------------------------
 //MARK: extensiono Chat
 - Description: Initializer
 -----------------------------------------------------------------------*/
extension Chat {
    init?(dictionary: [String:Any]) {
    guard let chatUsers = dictionary["users"] as? [String] else {return nil}
    self.init(users: chatUsers)
    }
}
