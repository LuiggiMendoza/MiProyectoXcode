//
//  LibVCViewController.swift
//  LibRaulito
//
//  Created by DAMII on 3/12/24.
//

import UIKit

class LibVCViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var listLibs : [LibStruc] = []
    
    
    @IBOutlet weak var libCollectionView: UICollectionView!
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listLibs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "libCell", for: indexPath) as! LibCollectionViewCell
        
        let lib = listLibs[indexPath.row]
        cell.productoImageView.image = UIImage(named: lib.urlImage)
        cell.nameLabel.text = lib.name
        
        cell.layer.cornerRadius = 30
        
        
        return cell
    }
    
    
    


//implementar la logica para extraer la informacion
//de una base de datos
private func setupRooms(){
    listLibs.append(LibStruc(name: "Libro", urlImage: "libro"))
    listLibs.append(LibStruc(name: "Lapiceros", urlImage: "lapicero"))
    listLibs.append(LibStruc(name: "Cuadernos", urlImage: "cuaderno"))
    
}


    override func viewDidLoad() {
        super.viewDidLoad()
        //cambiar la fuente de datos luego de implementar la logica
        libCollectionView.dataSource = self
        libCollectionView.delegate = self
        
        setupRooms()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Crear la vista destino
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productoDetalleView") as! ProductoViewController
        
        // Si deseas pasar datos al siguiente controlador, puedes hacerlo aquí
        // detailViewController.someProperty = someValue
        
        // Navegar al siguiente controlador
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}


    


