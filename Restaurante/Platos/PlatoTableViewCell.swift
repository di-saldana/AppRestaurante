
import UIKit

class PlatoTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    var index : IndexPath!
    weak var delegate: PlatoTableViewCellDelegate?
    
    @IBAction func botonAñadirPulsado(_ sender: Any) {
        self.delegate?.platoAñadido(indexPath: index)
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
