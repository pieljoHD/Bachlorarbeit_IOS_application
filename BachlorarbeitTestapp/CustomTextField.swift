//
//  CustomTextField.swift
//  BachlorarbeitTestapp
//
//  Created by johannes pielmeier on 13.12.24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let id: String
    let placeholderString: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            if isSecure {
                SecureField("", text: $text)
                    .accessibilityIdentifier(id)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholderString).foregroundColor(Color(hex: "666666"))
                    }
            } else {
                TextField(
                    "",
                    text: $text
                )
                .autocapitalization(.none)
                .accessibilityIdentifier(id)
                .placeholder(when: text.isEmpty) {
                    Text(placeholderString).foregroundColor(Color(hex: "666666"))
                }
                .accentColor(Color.black)
            }
            if text.isEmpty == false {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .foregroundColor(.secondary)
                .accessibilityIdentifier("clearButtonUserName")
            }
           
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(RoundedRectangle(cornerRadius: 4).fill(Color(hex: "FFF1ECE6")))
        .padding(.vertical, 6)
        .padding(.horizontal, 44)
    }
}

#Preview {
    CustomTextField(text:.constant("test123"), id: "fesf", placeholderString: "Benutzername")
}
