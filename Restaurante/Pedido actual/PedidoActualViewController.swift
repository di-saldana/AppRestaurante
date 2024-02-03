

import UIKit
import CoreData

class PedidoActualViewController: UIViewController, UITableViewDataSource, LineaPedidoTableViewCellDelegate {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBAction func realizarPedidoPulsado(_ sender: Any) {
        print("Pedido realizado")
    }
    
    
    @IBAction func cancelarPedidoPulsado(_ sender: Any) {
        print("Pedido cancelado")
    }
    
    //TODO: descomentar esta línea!!!!
    //var platoElegido : Plato!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        //TODO:
        // - crear el pedido actual si no existe
        // - crear la linea de pedido y asociarla al plato y al pedido actual
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: devolver el número real de filas de la tabla
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLinea", for: indexPath) as! LineaPedidoTableViewCell
        //Necesario para que funcione el delegate
        celda.pos = indexPath.row
        celda.delegate = self
        
        //TODO: rellenar los datos de la celda
        
        return celda
    }
    
    func cantidadCambiada(posLinea: Int, cantidad: Int) {
        //TODO: actualizar la cantidad de la línea de pedido correspondiente    
    }
    
    
}
