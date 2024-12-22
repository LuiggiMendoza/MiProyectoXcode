//
//  ProductoViewController.swift
//  LibRaulito
//
//  Created by DAMII on 5/12/24.
//

import UIKit
import FirebaseFirestore

struct Producto {
    var id: String
    var fecha: String
    var nombre: String
    var descripcion: String
    var imagen: String
    var autor: String
}


class ProductoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    var productoList: [Producto] = []
    
    @IBOutlet weak var productoTableView: UITableView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productoTableView.dataSource = self
        productoTableView.delegate = self
        listFirestore()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoCell", for: indexPath) as! ProductoTableViewCell
        let producto = productoList[indexPath.row]
        cell.nombreLabel.text = producto.nombre
        cell.marcaLabel.text = producto.fecha
        cell.precioLabel.text = producto.autor
        cell.descripcionLabel.text = producto.descripcion
        
        if let url = URL(string: producto.imagen) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.portadaImageview.image = image
                        }
                    }
                }
            }
        }
            return cell
        }
        
        
        
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let producto = productoList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "noticiasDetalleView") as! ProductoDetalleViewController
        view.producto = producto
        self.navigationController?.pushViewController(view, animated: true)
    }
}


// Firebase
extension ProductoViewController {
    func listFirestore() {
        let db = Firestore.firestore()
        db.collection("noticias").getDocuments { query, error in
            if let error = error {
                print("Se presentó un error")
            } else {
                let productos = query?.documents.compactMap { document -> Producto? in
                    let data = document.data()
                    let id = document.documentID
                    guard let autor = data["autor"] as? String,
                         let nombre = data["nombre"] as? String,
                          let fecha = data["fecha"] as? String,
                          let descripcion = data["descripcion"] as? String,
                          let imagen = data["imagen"] as? String else {
                              return nil
                          }
                    return Producto(id: id, fecha: fecha, nombre: nombre, descripcion: descripcion, imagen: imagen, autor: autor)
                }
                self.productoList = productos ?? []
                self.productoTableView.reloadData()
            }
        }
    }
}
