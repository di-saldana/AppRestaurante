

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
    
    var platoElegido : Plato!


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
            
            do {
                try miContexto.save()
            } catch {
                print("Error al guardar el contexto: \(error)")
            }
        }
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: devolver el número real de filas de la tabla
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LineaPedido> = LineaPedido.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "plato == %@", platoElegido)
        
        do {
            let resultados = try miContexto.fetch(fetchRequest)
            return resultados.count
        } catch {
            print("Error fetching LineaPedido objects: \(error)")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLinea", for: indexPath) as! LineaPedidoTableViewCell
        
        //TODO: rellenar los datos de la celda
        let miDelegate = UIApplication.shared.delegate as! AppDelegate
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LineaPedido> = LineaPedido.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "plato == %@", platoElegido)
        
        do {
            let resultados = try miContexto.fetch(fetchRequest)
            if let lineaPedido = resultados.first {
                celda.nombreLabel.text = lineaPedido.plato?.nombre
                celda.cantidadLabel.text = "\(lineaPedido.cantidad)"
            } else {
                print("No LineaPedido object found for platoElegido: \(String(describing: platoElegido))")
            }
        } catch {
            print("Error fetching LineaPedido objects: \(error)")
        }
        
        //Necesario para que funcione el delegate
        celda.pos = indexPath.row
        celda.delegate = self

        return celda
    }
    
    func cantidadCambiada(posLinea: Int, cantidad: Int) {
        //TODO: actualizar la cantidad de la línea de pedido correspondiente    
    }
    
    
}
