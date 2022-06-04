//
//  ContentView.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/03.
//

import SwiftUI
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

struct LoginView: View {
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    
    @State var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                    .padding(.bottom)
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(.black)
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                    .stroke(.black, lineWidth: 3))
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        Rectangle()
                            .frame(height: 60)
                            .overlay {
                                Text(isLoginMode ? "Log In" : "Create Account")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                    }
                    .padding(.vertical)
                    
                    Text(loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
        }
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to login user:", error)
                loginStatusMessage = "Failed to login user: \(error)"
                return
            }
            
            print("Successfully logged in user: \(result?.user.uid ?? "")")
            
            loginStatusMessage = "Successfully logged in user: \(result?.user.uid ?? "")"
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Faild to create user:", error)
                loginStatusMessage = "Failed to create user: \(error)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            loginStatusMessage = "Successfully create user: \(result?.user.uid ?? "")"
            
            persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                loginStatusMessage = "Failed to push image to Storage: \(error)"
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    loginStatusMessage = "Failed to retreieve downloadURL: \(error)"
                    return
                }
                
                loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString ?? "url: ~")
                
                
                guard let url = url else { return }
                storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { error in
                if let error = error {
                    print(error)
                    loginStatusMessage = "\(error)"
                    return
                }
                
                print("Success")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
