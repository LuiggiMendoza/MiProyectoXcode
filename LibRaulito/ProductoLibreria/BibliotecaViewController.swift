//
//  BibliotecaViewController.swift
//  LibRaulito
//
//  Created by DAMII on 17/12/24.
//

import UIKit
import FirebaseFirestore

struct Libro {
    var id: String
    var nombre: String
    var precio: String
    var descripcion: String
    var imagen: String
    var peso: String
}

class BibliotecaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return librosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bibliotecaCell", for: indexPath) as! BibliotecaTableViewCell
        let libro = librosList[indexPath.row]
        cell.nombreLabel.text = libro.nombre
        cell.marcaLabel.text = libro.peso
        cell.precioLabel.text = libro.precio
        cell.descripcionLabel.text = libro.descripcion
        
        if let url = URL(string: libro.imagen) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.portadaImageView.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    
    var librosList: [Libro] = []
    
    @IBOutlet weak var bibliotecaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bibliotecaTableView.dataSource = self
        bibliotecaTableView.delegate = self
        listFirestore()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let libro = librosList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "detalleView") as! DetalleViewController
        view.libro = libro
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    
    
}


// Firebase
extension BibliotecaViewController {
    func listFirestore() {
        let db = Firestore.firestore()
        db.collection("productos").getDocuments { query, error in
            if let error = error {
                print("Se presentó un error")
            } else {
                let libros = query?.documents.compactMap { document -> Libro? in
                    let data = document.data()
                    let id = document.documentID
                    guard let nombre = data["nombre"] as? String,
                            let peso = data["peso"] as? String,
                          let precio = data["precio"] as? String,
                          let descripcion = data["descripcion"] as? String,
                          let imagen = data["imagen"] as? String else {
                              return nil
                          }
                    return Libro(id: id, nombre: nombre, precio: precio, descripcion: descripcion, imagen: imagen, peso: peso)
                }
                self.librosList = libros ?? []
                self.bibliotecaTableView.reloadData()
            }
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
