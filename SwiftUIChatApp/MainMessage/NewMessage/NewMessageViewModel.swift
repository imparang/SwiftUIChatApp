//
//  NewMessageViewModel.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/05.
//

import SwiftUI

class NewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print(self.errorMessage)
                return
            }
            
            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                let user = ChatUser(data: data)
                if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(.init(data: data))
                }
            })
        }
    }
}
