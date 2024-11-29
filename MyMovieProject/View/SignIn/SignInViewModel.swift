import Foundation
import FirebaseAuth

final class SignInViewModel : ObservableObject {
    // CAMPOS QUE O USUÁRIO VAI PREENCHER
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var username : String = ""
    // VARIÁVEIS DE CONTROLE DE FLUXO
    @Published var presentLogIn : Bool = false
    @Published var goHome : Bool = false
    
    // VARIÁVEL QUE INFICA SE ESTÁ ACONTECENDO ALGUM PROCESSO ASSÍNCRONO
    @Published var waitingProcess : Bool = false

    // VARIÁVEIS RELACIONADAS AO ALERTA DE CAMPOS INVÁLIDOS.
    @Published var invalidFields : [String] = []
    @Published var showFieldAlert : Bool = false
    
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
        Task {
            do {
                let _ = try await Auth.auth().createUser(withEmail: email, password: password)
                Auth.auth().currentUser?.displayName = username

                print("[DEBUG] New user created successfully.")
                
                DispatchQueue.main.sync {
                    goHome = true
                }
            } catch {
                print("[ERROR] We had an issue creating a new user...")
            }
            
            DispatchQueue.main.sync {
                waitingProcess = false
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
        return password.count >= 5
    }
    
    private func isUsernameValid() -> Bool {
        return username.count >= 5
    }
    
    // MARK: FUNÇÕES PARA AJUDAR A MONTAR O ALERT DE CAMPOS INCORRETOS
    // função que retorna a mensagem do alerta que indica que algum dos campos está incorreto.
    func invalidFieldAlertMessage () -> String {
        let plural = invalidFields.count > 1
        
        var alertMessageText = "The field\(plural ? "s" : "") "
        for field in invalidFields {
            alertMessageText.append("\(field)\(plural ? " " : ", ")")
        }
        
        alertMessageText.append("\(plural ? "are" : "is") invalid...")
        return alertMessageText
    }
    
    // função executada quando o usuário aperta o botão de OK no alerta que indica que algum dos campos está incorreto.
    func okButtonInvalidFieldAlertPressed () {
        self.invalidFields.removeAll()
    }
}
