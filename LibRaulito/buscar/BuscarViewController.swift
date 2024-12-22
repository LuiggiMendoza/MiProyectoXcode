//
//  BuscarViewController.swift
//  LibRaulito
//
//  Created by DAMII on 18/12/24.
//

import UIKit
import FirebaseFirestore

class BuscarViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLibroList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuscarCell", for: indexPath)
        let libro = filteredLibroList[indexPath.row]
        
        cell.textLabel?.text = libro.nombre // Mostrar el nombre del corte
        cell.detailTextLabel?.text = "S/ \(libro.precio)" // Mostrar precio (si deseas detalles)
        return cell
    }
    

    
    @IBOutlet weak var buscarSearchBar: UISearchBar!
    
    @IBOutlet weak var buscarTableView: UITableView!
    
    
    var libroList: [Libro] = []
    var filteredLibroList: [Libro] = [] // Lista filtrada para la búsqueda
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        buscarTableView.dataSource = self
        buscarTableView.delegate = self
        buscarSearchBar.delegate = self
        
        // Registrar una celda básica (si no se configura en el storyboard)
        buscarTableView.register(UITableViewCell.self, forCellReuseIdentifier: "BuscarCell")
        
        loadLibros()
        // Do any additional setup after loading the view.
    }
    
    // Cargar datos desde Firebase
    private func loadLibros() {
        let db = Firestore.firestore()
        db.collection("productos").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error al obtener productos: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
            self?.libroList = documents.compactMap { doc -> Libro? in
                let data = doc.data()
                guard let nombre = data["nombre"] as? String,
                      let descripcion = data["descripcion"] as? String,
                      let peso = data["peso"] as? String,
                      let precio = data["precio"] as? String,
                      let imagen = data["imagen"] as? String else { return nil }
                let id = doc.documentID
                return Libro( id: id,nombre: nombre, precio: precio, descripcion: descripcion, imagen: imagen, peso: peso)
            }
            
            self?.filteredLibroList = self?.libroList ?? [] // Inicialmente, mostrar todos los datos
            self?.buscarTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLibro = filteredLibroList[indexPath.row]
        // Instanciar el controlador de detalle desde el storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "detalleView") as? DetalleViewController {
            // Pasar el objeto seleccionado al controlador de detalle
            detailVC.libro = selectedLibro
            
            // Navegar al detalle
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    
    
    // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredLibroList = libroList
        } else {
            filteredLibroList = libroList.filter { $0.nombre.lowercased().contains(searchText.lowercased()) }
        }
        buscarTableView.reloadData()
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
