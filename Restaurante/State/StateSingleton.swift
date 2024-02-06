
//Singleton para almacenar el estado de la aplicación
class StateSingleton {
    var pedidoActual:Pedido!
    
    private init(){
    }
    
    static let shared = StateSingleton()
}
