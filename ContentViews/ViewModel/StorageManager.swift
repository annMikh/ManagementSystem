//
//  StorageManager.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 11.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    private let storage = Storage.storage()
    private let session = Session.shared
    private let directory = "uploads/"
    
    func uploadImageData(data: UIImage, serverFileName: String) {
        let newImage = resizeImage(image: data, targetSize: CGSize(width: 100, height: 100))
        let fileRef = storage.reference().child(directory + serverFileName)
        
        DispatchQueue.global(qos: .utility).async {
            _ = fileRef.putData(newImage.pngData()!, metadata: nil) { metadata, error in
                fileRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
    func downloadImage(uid: String, handler: @escaping (Data?, Error?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            let storageRef = self.storage.reference().child("\(self.directory)\(uid).png")
            storageRef.getData(maxSize: 20 * 1024 * 1024, completion: handler)
        }
    }

}
