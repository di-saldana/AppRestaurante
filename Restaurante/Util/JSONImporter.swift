//
//  DataImporter.swift
//  Restaurante
//
//  Created by Otto Colomina Pardo on 10/12/2019.
//  Copyright © 2019 Otto Colomina Pardo. All rights reserved.
//

import Foundation


class JSONImporter {
    func importPlatosJSON(nomFich:String) ->[DatosPlato]? {
        if let urlFichero = Bundle.main.url(forResource: nomFich, withExtension: "json") ,
           let datosLeidos = try? Data(contentsOf: urlFichero) {
             let decoder = JSONDecoder()
             return try! decoder.decode([DatosPlato].self, from: datosLeidos)
        }
        else {
            return nil
        }
    }
}
