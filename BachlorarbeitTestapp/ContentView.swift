import SwiftUI



struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var isError: Bool = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                SecondScreen()
            } else {
                VStack {
                    TextField(
                        "",
                        text: $username
                    )
                    .autocapitalization(.none)
                    .accessibilityIdentifier("UsernameInput")
                    .placeholder(when: username.isEmpty) {
                        Text("Benutzername").foregroundColor(Color(hex: "666666"))
                    }
                    .accentColor(Color.black)
                    .padding([.horizontal], 15)
                    .padding([.vertical], 15)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color(hex: "FFF1ECE6")))
                    .padding([.horizontal], 40)
                    .padding([.bottom], 8)
                    .onTapGesture {isError = false}
                    
                    
                    SecureField("", text: $password)
                        .accessibilityIdentifier("PasswortInput")
                        .placeholder(when: username.isEmpty) {
                            Text("Passwort").foregroundColor(Color(hex: "666666"))
                        }
                        .accentColor(Color.black)
                        .padding([.horizontal], 15)
                        .padding([.vertical], 15)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color(hex: "FFF1ECE6")))
                        .padding([.horizontal], 40)
                        .onTapGesture {isError = false}
                    
                    
                    if(isError) {
                        Text("Benutzername oder Passwort falsch")
                            .foregroundColor(Color(hex: "FFd36969"))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 8)
                            .padding([.top], 8)
                            .accessibilityIdentifier("ErrorText")
                    }
                    
                    Button(action: {
                        //NEVER DO THIS IN A REAL PROJECT
                        dismissKeyboard()
                        if(username == "test123" && password == "1234") {
                            isLoggedIn = true
                        } else {
                            isError = true
                        }
                    }) {
                        Text("Login")
                            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 8)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 60).fill(Color(hex: "FF99CFC9")))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    .accessibilityIdentifier("LoginButton")
                }
                .padding()
            }
            
        }
    }
}

struct Todo: Identifiable {
    let name: String
    let id = UUID()
}




struct SecondScreen: View {
    @State private var newItem: String = ""
    @State private var items: [Todo] = []
    @State private var showDialog: Bool = false
    @State private var rowClickedId: UUID = UUID()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("Neues Element", text: $newItem)
                        .frame(minWidth: 30, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
                        .autocapitalization(.none)
                        .accentColor(Color.black)
                        .padding([.horizontal], 20)
                        .background(
                            UnevenRoundedRectangle(
                                cornerRadii: .init(topLeading: 25, bottomLeading: 25, bottomTrailing: 0, topTrailing: 0)).fill(Color(hex: "f1ece6")))
                        .padding(.trailing, -8)
                        .onChange(of: newItem) {}
                        .accessibilityIdentifier("TodoInput")
                    
                    Button(action: {
                        if !newItem.isEmpty {
                            items.append(Todo(name: newItem))
                            newItem = ""
                            dismissKeyboard()
                        }
                    }) {
                        Text("ADD")
                            .frame(minWidth: 0, maxWidth: 80, minHeight: 0, maxHeight: 55)
                            .background(
                                UnevenRoundedRectangle(
                                    cornerRadii: .init(topLeading: 0, bottomTrailing: 25, topTrailing: 25)).fill(Color(hex: "99CFC9")))
                            .foregroundColor(.white)
                    }
                    .accessibilityIdentifier("AddButton")
                    
                }
                Spacer().frame(maxHeight: 40)
                List(items)
                { item in
                    HStack{
                        Button(action: {
                            rowClickedId = item.id
                            showDialog = true
                        }) {
                            Text(item.name)
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        Button(action: {
                            items.removeAll(where: { $0.id == item.id })
                        }) {
                            Image(systemName: "trash.fill")
                                .padding([.horizontal],0)
                                .foregroundColor(Color(hex: "d36969"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listRowSeparatorTint(Color(hex: "99CFC9"))
                    .listRowBackground(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "f1ece6")))
                }
                .listStyle(.plain)
                .padding([.trailing], 20)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "f1ece6")))
            }
            .padding([.horizontal], 26)
            
            if(showDialog) {
                ChangeDialog(
                    isShown: $showDialog,
                    todo: items.first(where: { $0.id == rowClickedId })?.name ,
                    save: setNewTodo
                )
            }
        }
    }
    
    func setNewTodo(todo: String) {
        if let index = items.firstIndex(where: { $0.id == rowClickedId}) {
            items[index] = Todo(name: todo)
        }
    }
}

func dismissKeyboard() {
     UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
   }

extension View {
    func button(action: @escaping () -> Void) -> some View {
        modifier(ButtonWrapper(action: action))
    }
}
struct ButtonWrapper: ViewModifier {
    
    var action: () -> Void
    
    @ViewBuilder
    func body(content: Content) -> some View {
        Button {
            action()
        } label: {
            content
        }
        .contentShape(Rectangle())
    }
}



#Preview {
    ContentView()
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
