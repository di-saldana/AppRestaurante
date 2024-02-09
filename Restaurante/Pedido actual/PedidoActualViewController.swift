

import UIKit
import CoreData

class PedidoActualViewController: UIViewController, UITableViewDataSource, LineaPedidoTableViewCellDelegate {
    
    var platoElegido : Plato!
    var lineasPedido : [LineaPedido] = []

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBAction func realizarPedidoPulsado(_ sender: Any) {
        // Verifica si hay líneas de pedido
        guard !lineasPedido.isEmpty else {
            let alert = UIAlertController(title: "Seleccione los platos a añadir al pedido", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cerrar", comment: "This closes alert"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // Verifica si ya existe un pedido actual
        guard StateSingleton.shared.pedidoActual == nil else {
            // Si ya hay un pedido, muestra un mensaje
            let alert = UIAlertController(title: "Pedido realizado", message: "Su pedido está en camino.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cerrar", comment: "This closes alert"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Pedido realizado")
            return
        }

        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let pedido = Pedido(context: miContexto)
        pedido.fecha = Date()
        
        // Asigna las líneas de pedido al pedido actual
        for lineaPedido in lineasPedido {
            lineaPedido.pedido = pedido
        }
        
        StateSingleton.shared.pedidoActual = pedido
        
        do {
            try miContexto.save()
            
            let alert = UIAlertController(title: "Pedido realizado", message: "Su pedido está en camino.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cerrar", comment: "This closes alert"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Pedido realizado")
        } catch {
            print("Error al guardar el contexto: \(error)")
        }
    }
    
    @IBAction func cancelarPedidoPulsado(_ sender: Any) {
        guard let pedidoActual = StateSingleton.shared.pedidoActual else {
            return
        }
        
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LineaPedido> = LineaPedido.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pedido == %@", pedidoActual)
        
        do {
            let lineasPedido = try miContexto.fetch(fetchRequest)
            
            for lineaPedido in lineasPedido {
                miContexto.delete(lineaPedido)
            }
            
            // Limpia la variable lineasPedido
            self.lineasPedido.removeAll()
            
            try miContexto.save()
            
            miContexto.delete(pedidoActual)
            try miContexto.save()
            
            StateSingleton.shared.pedidoActual = nil
            
            // Limpia la tabla
            self.tabla.reloadData()
            
            let alert = UIAlertController(title: "Pedido cancelado", message: "Su pedido ha sido cancelado correctamente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cerrar", comment: "This closes alert"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Pedido cancelado")
        } catch {
            print("Error al eliminar el pedido y sus líneas: \(error)")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        
        if StateSingleton.shared.pedidoActual == nil {
            let miDelegate = UIApplication.shared.delegate! as! AppDelegate
            let miContexto = miDelegate.persistentContainer.viewContext
            
            let pedidoActual = Pedido(context: miContexto)
            pedidoActual.fecha = Date()
            
            StateSingleton.shared.pedidoActual = pedidoActual
            
            do {
                try miContexto.save()
            } catch {
                print("Error al guardar el contexto: \(error)")
            }
        }
        
        if let platoElegido = self.platoElegido {
            // Verifica si ya hay una línea de pedido para el plato seleccionado
            let existingLineaPedido = lineasPedido.first { $0.plato == platoElegido }
            
            if existingLineaPedido == nil {
                let miDelegate = UIApplication.shared.delegate as! AppDelegate
                let miContexto = miDelegate.persistentContainer.viewContext
                
                let nuevaLineaPedido = LineaPedido(context: miContexto)
                nuevaLineaPedido.cantidad = 1
                nuevaLineaPedido.plato = platoElegido
                nuevaLineaPedido.pedido = StateSingleton.shared.pedidoActual
                
                do {
                    try miContexto.save()
                } catch {
                    print("Error al guardar el contexto: \(error)")
                }
                
                self.tabla.reloadData()
                fetchLineasPedido()
            }
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineasPedido.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLinea", for: indexPath) as! LineaPedidoTableViewCell
        
        let lineaPedido = lineasPedido[indexPath.row]
        celda.nombreLabel.text = lineaPedido.plato?.nombre
        celda.cantidadLabel.text = "\(lineaPedido.cantidad)"
        
        //Necesario para que funcione el delegate
        celda.pos = indexPath.row
        celda.delegate = self
        
        cantidadCambiada(posLinea: indexPath.row, cantidad: Int(lineaPedido.cantidad))

        return celda
    }
    
    // TODO: Check que no hayan rows repetidas, sino que se cambie la cantidad del item
    func cantidadCambiada(posLinea: Int, cantidad: Int) {
        guard posLinea < lineasPedido.count else {
            return
        }
        
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let lineaPedido = lineasPedido[posLinea]
        lineaPedido.cantidad = Int16(cantidad)
        
        do {
            try miContexto.save()
        } catch {
            print("Error al guardar el contexto: \(error)")
        }
    }
    
    func fetchLineasPedido() {
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LineaPedido> = LineaPedido.fetchRequest()
        
        do {
            lineasPedido = try miContexto.fetch(fetchRequest)
        } catch {
            print("Error fetching LineaPedido objects: \(error)")
        }
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
    
}
