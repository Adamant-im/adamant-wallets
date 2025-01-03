//
//  AssetManager.swift
//  AdamantWalletsAssets
//
//  Created by Владимир Клевцов on 3.1.25..
//
import Foundation

public struct AssetManager {
    public static func loadInfoFiles() -> [String: Any] {
        var infoFiles = [String: Any]()
        
        guard let resourceURL = Bundle.module.url(forResource: "general", withExtension: nil) else {
            print("Failed to find 'general' folder.")
            return [:]
        }
        
        do {
            let subdirectories = try FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for subdirectory in subdirectories {
                let infoFileURL = subdirectory.appendingPathComponent("info")
                
                if FileManager.default.fileExists(atPath: infoFileURL.path) {
                    do {
                        let data = try Data(contentsOf: infoFileURL)
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        infoFiles[subdirectory.lastPathComponent] = jsonObject
                    } catch {
                        print("Failed to parse JSON from file at \(infoFileURL.path): \(error)")
                    }
                }
            }
        } catch {
            print("Error loading info files: \(error)")
        }
        
        return infoFiles
    }
}
