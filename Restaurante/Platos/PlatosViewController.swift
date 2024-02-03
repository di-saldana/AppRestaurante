

import UIKit
import CoreData

class PlatosViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, PlatoTableViewCellDelegate  {
    var frc : NSFetchedResultsController<Plato>!
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        //TODO: crear un NSFetchedResultsController
        
        let miDelegate = UIApplication.shared.delegate! as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let consulta = NSFetchRequest<Plato>(entityName: "Plato")
        let sortDescriptors = [NSSortDescriptor(key:"tipo", ascending:false)]
        consulta.sortDescriptors = sortDescriptors
        self.frc = NSFetchedResultsController<Plato>(fetchRequest: consulta, managedObjectContext: miContexto, sectionNameKeyPath: "tipo", cacheName: nil)

        try! self.frc.performFetch()
        
        if let resultados = frc.fetchedObjects {
            print("Hay \(resultados.count) platos")
            for plato in resultados {
                print (plato.nombre!)
            }
        }
        
        self.frc.delegate = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO devolver el número de filas en la sección
        return self.frc.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return self.frc.sections?[section].name
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPlato", for: indexPath) as! PlatoTableViewCell
        
        //Necesario para que funcione el botón "añadir"
        celda.delegate = self
        celda.index = indexPath
        
        //TODO: rellenar la celda con los datos del plato: nombre, precio y descripción
        //Para formato moneda puedes usar un NumberFormatter con estilo moneda
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        let formateado = fmt.string(from: NSNumber(value: 10.7)) //€10.70
        
        let plato = self.frc.object(at: indexPath)
        celda.nombreLabel?.text = plato.nombre!
        celda.precioLabel?.text = String(plato.precio)
        celda.descripcionLabel?.text = plato.descripcion!
        
        return celda
    }
    
    //Se ha pulsado el botón "Añadir"
    func platoAñadido(indexPath: IndexPath) {
        //TODO: obtener el Plato en la posición elegida
        let platoElegido : Plato! = self.frc.object(at: indexPath)
        
        //Le pasamos el plato elegido al controller de la pantalla de pedido
        //Y saltamos a esa pantalla
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tu Pedido") as! PedidoActualViewController
        
        //TODO: DESCOMENTAR ESTA LINEA!!!!!!!!!
//        vc.platoElegido = platoElegido
        
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
