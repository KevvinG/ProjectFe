//
//  Message.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-09.
//

//MARK: Imports
import Foundation
import UIKit
import Firebase
import MessageKit

/*------------------------------------------------------------------------
 //MARK: struct Message
 - Description: Message from bluetooth device to mobile phone.
 -----------------------------------------------------------------------*/
struct Message {
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    var dictionary: [String: Any] {
    return [
    "id": id,
    "content": content,
    "created": created,
    "senderID": senderID,
    "senderName":senderName]
    }
}

/*------------------------------------------------------------------------
 //MARK: extension Message
 - Description: initializer
 -----------------------------------------------------------------------*/
extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
        let content = dictionary["content"] as? String,
        let created = dictionary["created"] as? Timestamp,
        let senderID = dictionary["senderID"] as? String,
        let senderName = dictionary["senderName"] as? String
        else {return nil}
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
    }
}

/*------------------------------------------------------------------------
 //MARK: extension Message: MessageType
 - Description: Returns sender types for message.
 -----------------------------------------------------------------------*/
extension Message: MessageType {
    var sender: SenderType {
        return ChatUser(senderId: senderID, displayName: senderName)
    }
    var messageId: String {
        return id
    }
    var sentDate: Date {
        return created.dateValue()
    }
    var kind: MessageKind {
        return .text(content)
    }
}
