//
//  LoginViewController.swift
//  LibRaulito
//
//  Created by DAMII on 29/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var contraseñaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func login(_ sender: Any) {
        let correo =  correoTextField.text!
        let clave = contraseñaTextField.text!
        verifyFirebase(email: correo, pass: clave)
    }
    
    private func verifyFirebase(email: String, pass: String) {
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: pass) { (result, error) in
            if let user = result {
                let uid = user.user.uid
                UserDefaults.standard.set(uid, forKey: "uid")
                UserDefaults.standard.set(true, forKey: "login")
                self.goToMenu()
            } else {
                self.showAlertError()
            }
        }
    }
    
    private func showAlertError(){
        let alert = UIAlertController(title: "Error", message: "Verifique sus credenciales", preferredStyle: .alert)
        let action = UIAlertAction(title: "Entiendo", style: .default )
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    private func goToMenu(){
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let view = storybord.instantiateViewController(withIdentifier: "MenuView") as! MenuViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true)
    }
    

}
