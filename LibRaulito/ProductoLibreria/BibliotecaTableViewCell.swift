//
//  BibliotecaTableViewCell.swift
//  LibRaulito
//
//  Created by DAMII on 17/12/24.
//

import UIKit

class BibliotecaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var portadaImageView: UIImageView!
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var marcaLabel: UILabel!
    
    @IBOutlet weak var descripcionLabel: UILabel!
    
    @IBOutlet weak var precioLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
