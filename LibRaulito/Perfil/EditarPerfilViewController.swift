//
//  EditarPerfilViewController.swift
//  LibRaulito
//
//  Created by DAMII on 16/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditarPerfilViewController: UIViewController {
    
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cargarDatosUsuario()
        // Do any additional setup after loading the view.
    }
    
    private func cargarDatosUsuario() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("usuarios").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(), error == nil {
                self.nombreTextField.text = data["nombres"] as? String
                self.apellidoTextField.text = data["apellidos"] as? String
                self.correoTextField.text = data["correo"] as? String
            } else {
                self.showAlertError(mensaje: "Error al cargar los datos.")
            }
        }
    }
    
    @IBAction func guardarCambios(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let nuevosDatos = [
            "nombres": nombreTextField.text!,
            "apellidos": apellidoTextField.text!,
            "correo": correoTextField.text!
        ]
        
        db.collection("usuarios").document(uid).updateData(nuevosDatos) { error in
            if let error = error {
                self.showAlertError(mensaje: "No se pudieron guardar los cambios.")
            } else {
                self.showAlertSuccess()
            }
        }
    }
    
    private func showAlertError(mensaje: String) {
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alert, animated: true)
 }
    private func showAlertSuccess() {
        let alert = UIAlertController(
            title: "Éxito",
            message: "Los datos se actualizaron correctamente.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            self.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }

    
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


