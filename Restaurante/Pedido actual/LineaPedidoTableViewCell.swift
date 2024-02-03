

import UIKit

class LineaPedidoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    var pos : Int = 0
    weak var delegate : LineaPedidoTableViewCellDelegate?
    
    
    @IBAction func stepperPulsado(_ sender: UIStepper) {
        let valor = Int(sender.value)
        self.cantidadLabel.text = String(valor)
        self.delegate?.cantidadCambiada(posLinea: pos, cantidad: valor)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
