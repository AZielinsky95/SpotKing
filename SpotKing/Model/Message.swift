//
//  Message.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-10.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var fromId:String?
    var text:String?
    var toId:String?
    
    init(fromID:String?,text:String?,toID:String?)
    {
        self.fromId = fromID
        self.text = text
        self.toId = toID
    }
    
    func chatPartnerId() -> String?
    {
        return fromId == DatabaseManager.currentUserId ? toId : fromId
    }
}
