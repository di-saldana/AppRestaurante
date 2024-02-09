
import UIKit
import CoreData

class PedidosViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    
    var frc: NSFetchedResultsController<Pedido>!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc.sections?[section].numberOfObjects ?? 0
    }
    
    // TODO: Add total
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaHistorial", for: indexPath) as! PedidosTableViewCell

        let pedido = self.frc.object(at: indexPath)
        
        if let fecha = pedido.fecha {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            celda.fechaLabel?.text = dateFormatter.string(from: fecha)
        } else {
            celda.fechaLabel?.text = "Fecha desconocida"
        }
        
        celda.numPlatosLabel?.text = "\(pedido.lineasPedido?.count ?? 0)"

        return celda
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabla.dataSource = self

        let miDelegate = UIApplication.shared.delegate! as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext

        let consulta = NSFetchRequest<Pedido>(entityName: "Pedido")
        let sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        consulta.sortDescriptors = sortDescriptors
        self.frc = NSFetchedResultsController<Pedido>(fetchRequest: consulta, managedObjectContext: miContexto, sectionNameKeyPath: nil, cacheName: nil)

        try! self.frc.performFetch()
        self.frc.delegate = self
    }
    
    // NSFetchedResultsControllerDelegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tabla.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tabla.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.tabla.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tabla.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                self.tabla.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                self.tabla.deleteRows(at: [indexPath], with: .fade)
                self.tabla.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            fatalError("Unexpected NSFetchedResultsChangeType")
        }
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
