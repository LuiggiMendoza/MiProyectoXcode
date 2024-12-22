//
//  RecuperarContraseñaViewController.swift
//  LibRaulito
//
//  Created by DAMII on 16/12/24.
//

import UIKit
import FirebaseAuth

class RecuperarContrasen_aViewController: UIViewController {
    
    @IBOutlet weak var correoTextField: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        configurarUI()
        // Do any additional setup after loading the view.
    }
    
    private func configurarUI() {
        correoTextField.placeholder = "Ingresa tu correo electrónico"
    }
    
    
    @IBAction func enviar(_ sender: Any) {
        guard let email = correoTextField.text, !email.isEmpty else {
            mostrarAlerta(mensaje: "Por favor, ingresa tu correo electrónico.")
            return
    }
    
    
    
    
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.mostrarAlerta(mensaje: "Error: \(error.localizedDescription)")
            } else {
                self.mostrarAlerta(mensaje: "Se ha enviado un correo para restablecer tu contraseña.", exito: true)
            }
            
        }
    }
    
    private func mostrarAlerta(mensaje: String, exito: Bool = false) {
        let alert = UIAlertController(title: exito ? "Éxito" : "Error", message: mensaje, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            if exito {
                // Si es exitoso, regresa a la pantalla anterior
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    


}
