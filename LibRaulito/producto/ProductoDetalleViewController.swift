//
//  ProductoDetalleViewController.swift
//  LibRaulito
//
//  Created by DAMII on 5/12/24.
//

import UIKit
import FirebaseFirestore

class ProductoDetalleViewController: UIViewController {

    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var noticiasImageView: UIImageView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var autorLabel: UILabel!
    
    var producto: Producto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let producto = producto {
            nombreLabel.text = producto.nombre
            fechaLabel.text = producto.fecha
            descripcionLabel.text = producto.descripcion
            autorLabel.text = producto.autor
            
            if let imageUrl = URL(string: producto.imagen) {
                // Código para cargar la imagen
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error al cargar la imagen: \(error.localizedDescription)")
                        return
                    }
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.noticiasImageView.image = image
                        }
                    }
                }.resume()
            } else {
                print("URL inválida: \(producto.imagen)")
            }

        }

        // Do any additional setup after loading the view.
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
