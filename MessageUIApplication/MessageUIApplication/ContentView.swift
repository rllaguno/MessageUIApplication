//
//  ContentView.swift
//  MessageUIApplication
//
//  Created by Rodrigo Llaguno on 24/11/24.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var recipient: String = ""
    @State private var subject: String = ""
    @State private var message: String = ""
    @State private var image: UIImage?
    @State private var pickerItem: PhotosPickerItem?
    @State private var showEmailView: Bool = false
    
    var disabled: Bool {
        recipient.isEmpty || subject.isEmpty || message.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Recipient") {
                    TextField("Enter the recipient's email", text: $recipient)
                        .keyboardType(.emailAddress)
                }
                
                Section("Subject") {
                    TextField("Enter the subject", text: $subject)
                        .keyboardType(.default)
                }
                
                Section("Body") {
                    TextField("Enter the email's body", text: $message, axis: .vertical)
                        .keyboardType(.default)
                }
                
                Section("Image") {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        PhotosPicker("Append Image from Gallery", selection: $pickerItem, matching: .images)
                            .onChange(of: pickerItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        self.image = uiImage
                                    }
                                }
                            }
                    }
                }
                
                Section {
                    Button {
                        showEmailView.toggle()
                    } label: {
                        Text("Send Email")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(disabled ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                    .disabled(disabled)
                    
                }
            }
            .navigationTitle("Send Email")
            .sheet(isPresented: $showEmailView) {
                EmailView(
                    recipient: recipient,
                    subject: subject,
                    body: message,
                    image: image
                )
            }
            
        }
    }
}

#Preview {
    ContentView()
}
