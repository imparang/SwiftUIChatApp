//
//  MainMessageView.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/04.
//

import SwiftUI

struct MainMessageView: View {
    @State var shouldShowLogOutOptions = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Current user id: \(vm.errorMessage)")
                
                // custom nav bar
                customNavBar
                // messages view
                messagesView
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack {
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(uiColor: .lightGray))
                }
            }
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(uiColor: .label))
            }
        }
        .padding()
        .confirmationDialog("Settings", isPresented: $shouldShowLogOutOptions, titleVisibility: .visible) {
            Button(role: .destructive) {
                
            } label: {
                Text("Sign Out")
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("What do you want to do?")
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0 ..< 10, id: \.self) { num in
                VStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(uiColor: .label), lineWidth: 1)
                            )
                        VStack(alignment: .leading) {
                            Text("username")
                                .font(.system(size: 16, weight: .bold))
                            Text("message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(uiColor: .lightGray))
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
    }
}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageView()
            .preferredColorScheme(.dark)
        
        MainMessageView()
    }
}

class MainMessagesViewModel: ObservableObject {
    @Published var errorMessage = ""
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        errorMessage = "\(uid)"
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            print(data)
        
        }
    }
}
