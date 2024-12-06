import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SignInViewModel : ObservableObject {
    // CAMPOS QUE O USUÁRIO VAI PREENCHER
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var username : String = ""
    @Published var repeatPassword : String = ""
    
    // VARIÁVEIS DE CONTROLE DE FLUXO
    @Published var goHome : Bool = false
    
    // VARIÁVEL QUE INFICA SE ESTÁ ACONTECENDO ALGUM PROCESSO ASSÍNCRONO
    @Published var waitingProcess : Bool = false

    // VARIÁVEIS RELACIONADAS AO ALERTA DE CAMPOS INVÁLIDOS.
    @Published var invalidFields : [String] = []
    @Published var showFieldAlert : Bool = false
    
    let db = Firestore.firestore()
    
    // Função quando o usuário aperta no botão de se cadastrar
    func signIn () {
        
        // valida os campos
        
        if !isEmailValid() {
            invalidFields.append("email")
            showFieldAlert = true
        }
        
        if !isPasswordValid() {
            invalidFields.append("password")
            showFieldAlert = true
        }
        
        if !isUsernameValid() {
            invalidFields.append("username")
            showFieldAlert = true
        }
        
        if showFieldAlert {
            return
        }
        
        // agora o programa cria o novo usuário no banco de dados de maneira assíncrona
        waitingProcess = true
        checkUsernameExists(username) {result in
            Task {
                if !result {
                    self.invalidFields.append("username")
                    self.showFieldAlert = true
                } else {
                    let authDataResult = try await Auth.auth().createUser(withEmail: self.email, password: self.password).user
                    //authDataResult.displayName = self.username
                    let idGenerated = authDataResult.uid
                    try await self.db.collection("user_data").addDocument(data: [
                        "id" : idGenerated,
                        "name" : self.username
                    ])
                    
                    
                    try await Auth.auth().updateCurrentUser(authDataResult)
                    print("[DEBUG] New user created successfully.")
                    
                    DispatchQueue.main.sync {
                        self.goHome = true
                    }
                }
                
                DispatchQueue.main.sync {
                    self.waitingProcess = false
                }
            }
        }
    }
    
    // MARK: VALIDAÇÕES DOS CAMPOS
    private func isEmailValid() -> Bool {
        if email.count < 5 {
            return false
        }
        
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isPasswordValid() -> Bool {
        return password.count >= 5 && self.password == self.repeatPassword
    }
    
    private func isUsernameValid() -> Bool {
        return username.count >= 4
    }
    
    // MARK: FUNÇÕES PARA AJUDAR A MONTAR O ALERT DE CAMPOS INCORRETOS
    // função que retorna a mensagem do alerta que indica que algum dos campos está incorreto.
    func invalidFieldAlertMessage () -> String {
        let plural = invalidFields.count > 1
        
        var alertMessageText = "The field\(plural ? "s" : "") "
        for field in invalidFields {
            alertMessageText.append("\(field)\(plural ? ", " : " ")")
        }
        
        alertMessageText.append("\(plural ? "are" : "is") invalid...")
        return alertMessageText
    }
    
    // função executada quando o usuário aperta o botão de OK no alerta que indica que algum dos campos está incorreto.
    func okButtonInvalidFieldAlertPressed () {
        self.invalidFields.removeAll()
    }
    
    
    func checkUsernameExists (_ username : String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("displayName", isEqualTo: username)
            .getDocuments {snapshot, error in
                if let error {
                    print("[ERROR] Error fetching documents: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                if snapshot == nil || snapshot?.documents.isEmpty == true {
                    completion(true)
                } else {
                    completion(false)
                }
        }
    }
}
