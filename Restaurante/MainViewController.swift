

import UIKit
import CoreData

class MainViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Make sure que se carguen los datos del pedido cada vez
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                // Verificar si el controlador de vista es un PedidoActualViewController
                if let pedidoViewController = viewController as? PedidoActualViewController {
                    pedidoViewController.fetchLineasPedido()
                }
            }
        }
    }
}
