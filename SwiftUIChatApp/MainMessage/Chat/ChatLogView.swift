//
//  ChatLogView.swift
//  SwiftUIChatApp
//
//  Created by 정재윤 on 2022/06/05.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?
    
    @State var chatText = ""
    
    var body: some View {
        // VStack하면 스크롤할 떄 버그 생김 ;;\
        ZStack {
            messagesView
            
            VStack {
                Spacer()
                chatBottomBar
                    .background(.white)
            }
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<20) { _ in
                HStack {
                    Spacer()
                    
                    HStack {
                        Text("Fake message for now")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            HStack { Spacer() }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .padding(.bottom, 65)
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(uiColor: .darkGray))
            TextField("Description", text: $chatText)
            Button {
                
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["email": "test1@gmail.com", "uid": "NJniqtqOrfYiMV412w6j0Yoq6M03"]))
        }
    }
}
