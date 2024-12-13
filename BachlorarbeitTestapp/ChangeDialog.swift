//
//  ChangeDialog.swift
//  BachlorarbeitTestapp
//
//  Created by johannes pielmeier on 15.10.24.
//

import Foundation
import SwiftUI

struct ChangeDialog: View {
    
    @Binding var isShown: Bool

    var todo : String?
    
    let save: (String) -> ()
    
    @State private var todoChanged: String = ""
    
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
          VStack(alignment: .leading) {
              HStack {
                  TextField(
                      todo ?? "",
                      text: $todoChanged
                  )
                  .autocapitalization(.none)
                  .accessibilityIdentifier("changeTodoInput")
                  .accentColor(Color.black)

                  .onAppear {
                      todoChanged = todo ?? ""
                  }
                  
                  Button {
                      todoChanged = ""
                  } label: {
                      Image(systemName: "multiply.circle.fill")
                  }
                  .foregroundColor(.secondary)
                  .accessibilityIdentifier("clearButton")
                  
            }
              .padding(.horizontal)
              .padding(.vertical, 15)
              .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "FFEDE8D0")))
              .padding([.horizontal], 15)
              .padding([.top], 15)
              .padding([.bottom], -15)
               
                
                HStack {
                    Button {
                        close()
                    } label: {
                        Text("abbrechen")
                    }
                    .padding([.horizontal, ], 8)
                    .padding([.vertical, ], 4)
                    .buttonStyle(PlainButtonStyle())
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(hex: "FFd36969")))
                    
                    Button {
                        if(todoChanged != "") {
                            save(todoChanged)
                            isShown = false
                        }
                    } label: {
                        Text("speichern")
                    }
                    .padding([.horizontal, ], 8)
                    .padding([.vertical, ], 4)
                    .buttonStyle(PlainButtonStyle())
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(hex: "FF99CFC9")))
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottomTrailing)
                .padding()
            }
            .background(Color(hex: "FFF1ECE6"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 12)
            .padding([.horizontal], 50)
            
        }
        .ignoresSafeArea()
    }
    func close() {
        isShown = false
    }
}

#Preview {
    ChangeDialog(isShown: .constant(true), todo: "todo", save: test)
}

func test(test: String) {
    
}
