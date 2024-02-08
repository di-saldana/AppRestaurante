

import UIKit
import CoreData

class PedidoActualViewController: UIViewController, UITableViewDataSource, LineaPedidoTableViewCellDelegate {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    // TODO: Check que no se cree el pedido si no hay lineasPedido
    @IBAction func realizarPedidoPulsado(_ sender: Any) {
        // Verifica si ya existe un pedido actual y si hay líneas de pedido
        guard StateSingleton.shared.pedidoActual == nil && !lineasPedido.isEmpty else {
            // Si ya hay un pedido o no hay líneas de pedido, no se puede realizar otro pedido
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
            
            self.lineasPedido.removeAll()
            
            try miContexto.save()
            
            miContexto.delete(pedidoActual)
            try miContexto.save()
            
            StateSingleton.shared.pedidoActual = nil
            
            // TODO: Clean table view
//            self.tabla.reloadData()
            
            let alert = UIAlertController(title: "Pedido cancelado", message: "Su pedido ha sido cancelado correctamente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cerrar", comment: "This closes alert"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Pedido cancelado")
        } catch {
            print("Error al eliminar el pedido y sus líneas: \(error)")
        }
    }
    
    var platoElegido : Plato!
    var lineasPedido : [LineaPedido] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        
        if StateSingleton.shared.pedidoActual==nil {
            let miDelegate = UIApplication.shared.delegate! as! AppDelegate
            let miContexto = miDelegate.persistentContainer.viewContext
            
            let pedidoActual = Pedido(context: miContexto)
            pedidoActual.fecha = Date()
            
            let lineaPedido = LineaPedido(context: miContexto)
            lineaPedido.cantidad = 1
            lineaPedido.plato = platoElegido
            lineaPedido.pedido = pedidoActual
            
            StateSingleton.shared.pedidoActual = pedidoActual
            
            do {
                try miContexto.save()
            } catch {
                print("Error al guardar el contexto: \(error)")
            }
        }
        
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
        
        fetchLineasPedido()
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
    
    private func fetchLineasPedido() {
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LineaPedido> = LineaPedido.fetchRequest()
        
        do {
            lineasPedido = try miContexto.fetch(fetchRequest)
        } catch {
            print("Error fetching LineaPedido objects: \(error)")
        }
    }
    
}
