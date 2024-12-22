//
//  CarritoViewController.swift
//  LibRaulito
//
//  Created by DAMII on 18/12/24.
//

import UIKit
import FirebaseFirestore

class CarritoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var carritoTableView: UITableView!
    
    
    var productos: [Libro] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carritoTableView.dataSource = self
        carritoTableView.dataSource = self
        
        cargarCarrito()

        // Do any additional setup after loading the view.
    }
    
    private func cargarCarrito() {
        guard let carritoId = UserDefaults.standard.string(forKey: "carrito") else {
            emptyLabel.isHidden = false
            return
        }
        
        db.collection("carrito").document(carritoId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error al obtener carrito: \(error)")
                return
            }
            guard let data = document?.data(), let productIds = data["productos"] as? [String] else {
                self?.emptyLabel.isHidden = false
                return
            }
            
            self?.obtenerProductos(ids: productIds)
        }
    }
    
    private func obtenerProductos(ids: [String]) {
        guard !ids.isEmpty else {
            self.emptyLabel.isHidden = false
            return
        }

        db.collection("productos")
            .whereField(FieldPath.documentID(), in: ids)
            .getDocuments { (snapshot: QuerySnapshot?, error: Error?) in
                if let error = error {
                    print("Error al obtener productos: \(error)")
                    return
                }
                
                self.productos = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return Libro(
                        id: doc.documentID,
                        nombre: data["nombre"] as? String ?? "",
                        precio: data["precio"] as? String ?? "", descripcion: data["descripcion"] as? String ?? "",
                        imagen: data["imagen"] as? String ?? "",
                        peso: data["peso"] as? String ?? ""
                    )
                } ?? []
                
                DispatchQueue.main.async {
                    self.carritoTableView.reloadData()
                    self.emptyLabel.isHidden = !(self.productos.isEmpty)
                }
            }
    }
    
    // MARK: - Función para vaciar visualmente la tabla
       func limpiarTabla() {
           // Limpia el array de productos y recarga la tabla
           self.productos.removeAll()
           self.carritoTableView.reloadData()
           self.emptyLabel.isHidden = false // Muestra el mensaje de carrito vacío
       }

    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarritoCell", for: indexPath)
        let producto = productos[indexPath.row]
        cell.textLabel?.text = producto.nombre
        cell.detailTextLabel?.text = "S/. \(producto.precio)"
        return cell
    }

    
    @IBAction func cancelar(_ sender: UIButton) {
        limpiarTabla()
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
