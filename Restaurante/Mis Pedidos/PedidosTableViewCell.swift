//
//  HistorialTableViewCell.swift
//  Restaurante
//
//  Created by Dianelys Saldaña on 2/9/24.
//  Copyright © 2024 Otto Colomina Pardo. All rights reserved.
//

import UIKit

class PedidosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var numPlatosLabel: UILabel!
    
    var pos : Int = 0
    weak var delegate : PedidosTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
