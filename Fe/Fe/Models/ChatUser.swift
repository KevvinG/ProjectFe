//
//  ChatUser.swift
//  Fe
//
//  Created by Kevin Grzela on 2021-11-09.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
