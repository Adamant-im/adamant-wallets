//
//  AssetManager.swift
//  AdamantWalletsAssets
//
//  Created by Владимир Клевцов on 3.1.25..
//
import Foundation

public struct AssetManager {
    public static func loadInfoFiles() -> [Any] {
        var jsonFiles = [Any]()
        
        guard let resourceURL = Bundle.module.url(forResource: "general", withExtension: nil) else {
            print("Failed to find 'general' folder.")
            return []
        }
        
        do {
            let enumerator = FileManager.default.enumerator(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            while let fileURL = enumerator?.nextObject() as? URL {
                if fileURL.lastPathComponent == "info" {
                    do {
                        let data = try Data(contentsOf: fileURL)
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        // Добавляем JSON-объект в массив
                        jsonFiles.append(jsonObject)
                    } catch {
                        print("Failed to parse JSON from file at \(fileURL.path): \(error)")
                    }
                }
            }
        }
        return jsonFiles
    }
}
