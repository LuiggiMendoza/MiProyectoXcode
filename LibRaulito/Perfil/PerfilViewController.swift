//
//  PerfilViewController.swift
//  LibRaulito
//
//  Created by DAMII on 16/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PerfilViewController: UIViewController {

 
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var apellidosLabel: UILabel!
    
    
    @IBOutlet weak var correoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarDatosUsuario()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesion(_ sender: UIButton) {
        do {
                // Intentar cerrar sesión de Firebase
                try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "login")
                
                // Redirigir al usuario a la pantalla de inicio de sesión
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // Cambia "Main" si el storyboard tiene otro nombre
                if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVc") as? LoginViewController {
                    loginViewController.modalPresentationStyle = .fullScreen
                    self.present(loginViewController, animated: true, completion: nil)
                } else {
                    print("No se pudo instanciar LoginViewController")
                }
                
            } catch let error {
                print("Error al cerrar sesión: \(error.localizedDescription)")
            }
    }
    
    private func cargarDatosUsuario() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("usuarios").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(), error == nil {
                self.nombreLabel.text = data["nombres"] as? String
                self.apellidosLabel.text = data["apellidos"] as? String
                self.correoLabel.text = data["correo"] as? String
            } else {
                self.showAlertError()
            }
        }
    }
    private func showAlertError() {
        let alert = UIAlertController(title: "Error", message: "No se pudieron cargar los datos del usuario", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func eliminarCuenta(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmación", message: "¿Está seguro de que desea eliminar su cuenta? Esta acción no se puede deshacer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { _ in
            self.eliminarCuenta()
        }))
        self.present(alert, animated: true)
    }
    
    private func eliminarCuenta() {
        guard let user = Auth.auth().currentUser else { return }
        
        // Eliminar usuario de Firebase Authentication
        user.delete { error in
            if let error = error {
                self.showAlertError(mensaje: "No se pudo eliminar la cuenta. Inténtelo de nuevo.")
            } else {
                // Eliminar datos de Firestore
                self.eliminarDatosFirestore(uid: user.uid)
            }
        }
    }
    
    private func eliminarDatosFirestore(uid: String) {
        let db = Firestore.firestore()
        db.collection("usuarios").document(uid).delete { error in
            if let error = error {
                self.showAlertError(mensaje: "Error al eliminar datos del usuario.")
            } else {
                // Cerrar sesión después de eliminar los datos
                self.cerrarSesionTrasEliminacion()
            }
        }
    }

    private func cerrarSesionTrasEliminacion() {
        do {
            try Auth.auth().signOut()
            redirigirARegistro()
        } catch let error {
            self.showAlertError(mensaje: "Error al cerrar sesión: \(error.localizedDescription)")
        }
    }

    private func redirigirARegistro() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Asegúrate de que "Main" sea el nombre correcto
        if let registroViewController = storyboard.instantiateViewController(withIdentifier: "registrar") as? RegistroViewController {
            registroViewController.modalPresentationStyle = .fullScreen
            self.present(registroViewController, animated: true, completion: nil)
        } else {
            print("No se pudo instanciar RegistroViewController")
        }
    }

    private func showAlertError(mensaje: String) {
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
