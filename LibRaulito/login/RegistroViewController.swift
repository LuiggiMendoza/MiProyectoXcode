//
//  RegistroViewController.swift
//  LibRaulito
//
//  Created by DAMII on 3/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistroViewController: UIViewController {
    
    
    @IBOutlet weak var nombresTextField: UITextField!
    
    @IBOutlet weak var apellidosTextField: UITextField!
    
    
    @IBOutlet weak var correoTextField: UITextField!
    
    
    @IBOutlet weak var contraseñaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    

    @IBAction func registrar(_ sender: Any) {
        guard let nombres = nombresTextField.text, !nombres.isEmpty,
                      let apellidos = apellidosTextField.text, !apellidos.isEmpty,
                      let correo = correoTextField.text, !correo.isEmpty,
                      let clave = contraseñaTextField.text, !clave.isEmpty else {
                    showAlert(title: "Error", message: "Todos los campos son obligatorios.")
                    return
                }
                
                // Validar formato del correo
                guard isValidEmail(correo) else {
                    showAlert(title: "Error", message: "Por favor, ingresa un correo válido.")
                    return
                }
                
                // Validar longitud de la contraseña
                guard clave.count >= 6 else {
                    showAlert(title: "Error", message: "La contraseña debe tener al menos 6 caracteres.")
                    return
                }
                
                // Intentar registrar al usuario
                registerAuth(nombre: nombres, apellidos: apellidos, correo: correo, clave: clave)
            
    }
    private func registerAuth(nombre: String, apellidos: String , correo: String, clave: String) {
        let auth = Auth.auth()
        auth.createUser(withEmail: correo, password: clave) { (result, error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: "No se pudo registrar: \(error.localizedDescription)")
                        return
                    }
                    
                    if let user = result {
                        let uid = user.user.uid
                        self.registerFirestore(uid: uid, nombre: nombre, apellidos: apellidos, correo: correo)
                    }
                }
    }
    
    private func registerFirestore(uid: String, nombre: String,
                                   apellidos: String, correo: String) {
        let db = Firestore.firestore()
                db.collection("usuarios").document(uid).setData([
                    "nombres": nombre,
                    "apellidos": apellidos,
                    "correo": correo
                ]) { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: "No se pudo guardar el usuario: \(error.localizedDescription)")
                    } else {
                        self.showAlert(title: "Éxito", message: "Usuario registrado correctamente.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
        
        // MARK: - Alertas
        private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            })
            present(alert, animated: true, completion: nil)
        }
    
}
