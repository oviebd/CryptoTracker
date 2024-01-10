//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 10/1/24.
//

import Foundation
import UIKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init(){
        
    }

    func getImage(folderName : String, imageName : String) -> UIImage? {
        guard let url = getUrlForImage(folderName: folderName, imageName: imageName), FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    func saveImage(image : UIImage, folderName : String, imageName : String){
       
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(), let url = getUrlForImage(folderName: folderName, imageName: imageName) else{
            return
        }
        
        do {
            try data.write(to: url)
        }catch let error{
            print("Error image saving.. \(error.localizedDescription)")
        }
    }

    
    private func createFolderIfNeeded(folderName : String){
        guard let url = getUrlForFolder(folderName: folderName) else {return}
        if FileManager.default.fileExists(atPath: url.path) == false {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }catch let error {
                print("Error creating directory \(error.localizedDescription)")
            }
        }
    }
    
    private func getUrlForFolder(folderName : String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getUrlForImage(folderName : String, imageName : String) -> URL?{
        guard let folderUrl = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
