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
                if fileURL.lastPathComponent == "info.json" {
                    do {
                        let data = try Data(contentsOf: fileURL)
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        jsonFiles.append(jsonObject)
                    } catch {
                        print("Failed to parse JSON from file at \(fileURL.path): \(error)")
                    }
                }
            }
        }
        return jsonFiles
    }
  public static func saveImagesToDirectory() {
      let fileManager = FileManager.default
      
      guard let sourceDirectory = Bundle.module.url(forResource: "general", withExtension: nil) else {
          print("Failed to find 'general' folder in the bundle.")
          return
      }
      
      let destinationDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
          .appendingPathComponent("CustomAssets")

      do {
          if !fileManager.fileExists(atPath: destinationDirectory.path) {
              try fileManager.createDirectory(at: destinationDirectory, withIntermediateDirectories: true, attributes: nil)
          }
          
          let enumerator = fileManager.enumerator(at: sourceDirectory, includingPropertiesForKeys: nil)
          while let fileURL = enumerator?.nextObject() as? URL {
              if fileURL.pathExtension == "png" {
                  let destinationURL = destinationDirectory.appendingPathComponent(fileURL.lastPathComponent)
                  
                  if !fileManager.fileExists(atPath: destinationURL.path) {
                      try fileManager.copyItem(at: fileURL, to: destinationURL)
                  }
              }
          }
      } catch {
          print("Error saving images to directory: \(error)")
      }
  }
}
