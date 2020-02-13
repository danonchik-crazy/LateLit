//
//  Account.swift
//  LateLit
//
//  Created by Daniel Khromov on 2/11/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Firebase

struct SignIn: View {
    @State var email = ""
    @State var pass = ""
    @State var name = ""
    @State var surname = ""
    @State var empty = true
    @State var showAlert = false
    @State var alertText: String = ""
    @ObservedObject var signed = Settings()
    let ref = Database.database().reference(withPath: "Users")
    var body: some View {
            
            
            VStack {
                if(self.signed.Sign == false)
                {
        Text("Ваш аккаунт")
        .font(.largeTitle)
        .bold()
        TextField("Имя", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        TextField("Фамилия", text: $surname)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        TextField("Email", text: $email)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        SecureField("Пароль", text: $pass)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    HStack{
                Button(action: {
                    
                    Auth.auth().signIn(withEmail: self.email, password: self.pass)
                    {
                    (res, err) in
                
                    if err != nil
                    {
                        print((err!.localizedDescription))
                        self.alertText = err!.localizedDescription
                        self.showAlert = true
                    }
                    else{
                    self.signed.Sign = true
                        }
                }
            }) {
                
                Text("Войти")
                    .fontWeight(.medium)
                    .padding()
                    .background(Color("Color"))
                    .shadow(color: Color("Color"), radius: 10)
                    .foregroundColor(Color.white)
                    .cornerRadius(20.0)
                    .disabled(email.isEmpty || pass.isEmpty)
                    }
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Ошибка входа"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить вход")){self.signed.Sign = false})
                        })
                
                
            Button(action: {
                Auth.auth().createUser(withEmail: self.email, password: self.pass){
                    (res, err) in
                    if err != nil
                    {
                        print((err!.localizedDescription))
                        self.alertText = err!.localizedDescription
                        self.showAlert = true
                    }
                    else{
                    let userID = Auth.auth().currentUser?.uid
                    self.ref.child(userID!).setValue(["email" : self.email, "name": self.name, "password": self.pass, "role":"user", "surname":self.surname])
                    self.signed.Sign = true
                    }
                }
               
            }) {
                Text("Зарегистрироваться")
                    .fontWeight(.medium)
                .padding()
                .background(Color("Color"))
                .shadow(color: Color("Color"), radius: 10)
                .foregroundColor(.white)
                .cornerRadius(20.0)
                .disabled(email.isEmpty || pass.isEmpty)
                }
                
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Ошибка регистрации"), message: Text("\(alertText)"), dismissButton: .default(Text("Повторить вход")){self.signed.Sign = false})
                        })
                
               
                    }
                    
                Image("account")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                 Spacer()
                }
               
                
                else{
                    Text("Вы успешно вошли :)")
                        .font(.largeTitle)
                        .bold()
                    Image("nice")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                    Button(action: {
                        let fireBaseAuth = Auth.auth()
                        self.signed.Sign = false
                        do{
                            try fireBaseAuth.signOut()
                        }
                        catch let signOutError as NSError{
                            print(signOutError)
                        }
                    }){
                        Text("Выйти")
                    }
                    Spacer()
                }
    }
    }


struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
}
