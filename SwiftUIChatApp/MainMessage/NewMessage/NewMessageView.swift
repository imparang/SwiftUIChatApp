//
//  NewMessageView.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm = NewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users, id: \.id) { user in
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(uiColor: .label), lineWidth: 2)
                                }
                            
                            Text(user.email)
                                .foregroundColor(Color(uiColor: .label))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical)
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessageView()
    }
}
