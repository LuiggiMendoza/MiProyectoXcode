//
//  BilleteraViewController.swift
//  LibRaulito
//
//  Created by DAMII on 20/12/24.
//

import UIKit
import FirebaseFirestore

class BilleteraViewController: UIViewController {
    
    
    @IBOutlet weak var validacion: UITextField!
    var selectedProducts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func pagar(_ sender: Any){
        guard let validacion = validacion.text, !validacion.isEmpty else {
            showAlert(title: "Error", message: "Todos los campos son obligatorios.")
            return
        }
        
        let uid = UUID().uuidString
        registerFirestore(uid: uid, validacion: validacion)
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?() // Se ejecuta el bloque de código adicional aquí
        })
        present(alert, animated: true, completion: nil)
    }

    func registerFirestore(uid: String, validacion: String) {
        let db = Firestore.firestore()
        db.collection("billetera").document(uid).setData([
            "validacion": validacion
        ]) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "No se pudo guardar la validación: \(error.localizedDescription)")
            } else {
                self.clearSelectedProductsFromCart { success in
                    if success {
                        self.showAlert(title: "Éxito", message: "Producto pagado y productos seleccionados eliminados del carrito.") {
                            // Aquí es donde hacemos la acción para eliminar visualmente
                            if let menuView = self.navigationController?.viewControllers.first(where: { $0 is MenuViewController }) {
                                // Busca la instancia de CarritoViewController y ejecuta la limpieza
                                if let carritoVC = self.navigationController?.viewControllers.first(where: { $0 is CarritoViewController }) as? CarritoViewController {
                                    carritoVC.limpiarTabla() // Llama al método para vaciar la tabla
                                }
                                self.navigationController?.popToViewController(menuView, animated: true)
                            }
                        }
                    } else {
                        self.showAlert(title: "Error", message: "No se pudo limpiar los productos seleccionados del carrito.")
                    }
                }
            }
        }
    }

    
    func clearSelectedProductsFromCart(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let cartCollection = db.collection("carrito")
        let batch = db.batch()
        
        // Grupo para manejar las operaciones asincrónicas
        let dispatchGroup = DispatchGroup()
        
        for productID in selectedProducts {
            dispatchGroup.enter() // Inicia seguimiento de la tarea
            cartCollection.document(productID).getDocument { document, error in
                if let document = document, document.exists {
                    batch.deleteDocument(document.reference)
                } else if let error = error {
                    print("Error al obtener el producto \(productID): \(error.localizedDescription)")
                }
                dispatchGroup.leave() // Finaliza la tarea
            }
        }
        
        // Ejecutar después de que todas las operaciones hayan terminado
        dispatchGroup.notify(queue: .main) {
            batch.commit { error in
                if let error = error {
                    print("Error al eliminar los productos seleccionados del carrito: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
