
//Singleton para almacenar el estado de la aplicación
class StateSingleton {
    //TODO: descomentar esta variable cuando ya exista la entidad Pedido
    //var pedidoActual:Pedido!
    
    private init(){
    }
    
    static let shared = StateSingleton()
}
