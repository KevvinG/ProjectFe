//
//  ChatUser.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-09.
//

//MARK: Imports
import Foundation
import MessageKit

/*------------------------------------------------------------------------
 //MARK: struct ChatUser
 - Description: Strtuct for user foor chatbot.
 -----------------------------------------------------------------------*/
struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
