

import UIKit
import CoreData

class PlatosViewController: UIViewController, UITableViewDataSource, PlatoTableViewCellDelegate  {
    
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        //TODO: crear un NSFetchedResultsController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO devolver el número de filas en la sección
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //TODO: devolver el título de la sección
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: devolver el número de secciones
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPlato", for: indexPath) as! PlatoTableViewCell
        
        //Necesario para que funcione el botón "añadir"
        celda.delegate = self
        celda.index = indexPath
        
        //TODO: rellenar la celda con los datos del plato: nombre, precio y descripción
        //Para formato moneda puedes usar un NumberFormatter con estilo moneda
        //let fmt = NumberFormatter()
        //fmt.numberStyle = .currency
        //let formateado = fmt.string(from: NSNumber(value: 10.7)) //€10.70
        
        
        return celda
    }
    
    //Se ha pulsado el botón "Añadir"
    func platoAñadido(indexPath: IndexPath) {
        //TODO: obtener el Plato en la posición elegida
        //let platoElegido : Plato! = nil
        
        
        //Le pasamos el plato elegido al controller de la pantalla de pedido
        //Y saltamos a esa pantalla
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tu Pedido") as! PedidoActualViewController
        
        //TODO: DESCOMENTAR ESTA LINEA!!!!!!!!!
        //vc.platoElegido = platoElegido
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
