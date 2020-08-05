//
//  ViewController.swift
//  Project10
//
//  Created by Álvaro Ávalos Hernández on 14/01/20.
//  Copyright © 2020 Álvaro Ávalos Hernández. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        //permite al usuario editar la imagen
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //Obtención y escritura de imagen en Disco
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Parametro con el tipo de imagen recibida
        guard let image = info[.editedImage] as? UIImage else { return }
        //Identificador de la imagen
        let imageName = UUID().uuidString
        //Obtención de la URL para guardar la imagen en el directorio Documents
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        //Convierte en data
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            //escribe los datos en la ruta obtenida anteriormente
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        //1. solicita el directorio de documentos 2.la ruta sea relativa al directorio de inicio del usuario.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //Devuelve el directorio de documentos del usuario
        return paths[0]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue Person cell.")
        }
        
        let person = people[indexPath.item]

        cell.name.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName

            self?.collectionView.reloadData()
        })

        present(ac, animated: true)
    }
}

