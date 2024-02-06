

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
    var lineasPedido: [LineaPedido] = []


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
        fetchRequest.predicate = NSPredicate(format: "plato == %@", platoElegido)
        
        do {
            lineasPedido = try miContexto.fetch(fetchRequest)
        } catch {
            print("Error fetching LineaPedido objects: \(error)")
        }
    }
    
}
