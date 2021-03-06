//
//  ImageModel.swift
//  RichMessageKit
//
//  Created by Shivam Pokhriyal on 06/02/19.
//

import Foundation

public struct ImageMessage {
    public var caption: String?

    public var url: String

    public var message: Message

    public init(caption: String?, url: String, message: Message) {
        self.caption = caption
        self.url = url
        self.message = message
    }
}
