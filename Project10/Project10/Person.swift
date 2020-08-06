//
//  Person.swift
//  Project10
//
//  Created by Álvaro Ávalos Hernández on 05/08/20.
//  Copyright © 2020 Álvaro Ávalos Hernández. All rights reserved.
//

import UIKit

//Para usar NSCoding es necesario tener la clase como objeto

class Person: NSObject, NSCoding {
    
    //Se usa para guardar
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    //required = si alguien intenta subclasificar esta clase, debe implementar este método
    //si no se va a subclasificara entonces colocar la clase como final
    //Se usa para cargar los datos
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
