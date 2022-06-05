//
//  ChatUser.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/04.
//

import SwiftUI

struct ChatUser: Identifiable {
    var id: String { uid }
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
