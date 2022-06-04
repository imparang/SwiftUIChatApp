//
//  FirebaseMangager.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/04.
//

import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    var storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        auth = Auth.auth()
        storage = Storage.storage()
        firestore = Firestore.firestore()
        super.init()
    }
}
