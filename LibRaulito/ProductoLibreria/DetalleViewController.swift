//
//  DetalleViewController.swift
//  LibRaulito
//
//  Created by DAMII on 17/12/24.
//

import UIKit
import FirebaseFirestore

class DetalleViewController: UIViewController {
    
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var portadaImageView: UIImageView!
    @IBOutlet weak var marcaLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    
    var libro: Libro?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let libro = libro {
            nombreLabel.text = libro.nombre
            marcaLabel.text = libro.peso
            descripcionLabel.text = libro.descripcion
            precioLabel.text = libro.precio
            
            if let imageUrl = URL(string: libro.imagen) {
                // Código para cargar la imagen
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error al cargar la imagen: \(error.localizedDescription)")
                        return
                    }
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.portadaImageView.image = image
                        }
                    }
                }.resume()
            } else {
                print("URL inválida: \(libro.imagen)")
            }

        }
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func guardar(_ sender: Any) {
        let uid = UserDefaults.standard.string(forKey: "uid") ?? ""
        let productId = libro?.id ?? ""
        registerFirestore(uid: uid, productId: productId)
    }
    
    private func registerFirestore(uid: String, productId: String) {
        let db = Firestore.firestore()
        let idCarrito = UserDefaults.standard.string(forKey: "carrito")
        if let carrito = idCarrito {
            // actualizar
            db.collection("carrito").document(carrito).updateData([
                "productos": FieldValue.arrayUnion([productId]),
              ])
        } else {
            // crear
            let ref = db.collection("carrito").addDocument(data: [
                "usuario": uid,
                "productos": [productId]
            ])
            let document = ref.documentID
            UserDefaults.standard.set(document, forKey: "carrito")
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

}
