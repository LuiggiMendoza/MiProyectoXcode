//
//  TarjetaViewController.swift
//  LibRaulito
//
//  Created by DAMII on 20/12/24.
//

import UIKit
import FirebaseFirestore

class TarjetaViewController: UIViewController {

    
    @IBOutlet weak var tarjetaTextField: UITextField!
    @IBOutlet weak var caducidadTextField: UITextField!
    @IBOutlet weak var cciTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func pagar(_ sender: Any) {
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
