//
//  AssetManager.swift
//  adamant-wallets
//
//  Created by Владимир Клевцов on 3.1.25..
//


import Foundation

public struct AssetManager {
    public static func loadInfoFiles() -> [String: Data] {
        var infoFiles = [String: Data]()
        
        guard let resourceURL = Bundle.module.url(forResource: "general", withExtension: nil) else {
            print("Failed to find 'general' folder.")
            return [:]
        }
        
        do {
            let subdirectories = try FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for subdirectory in subdirectories {
                let infoFileURL = subdirectory.appendingPathComponent("info")
                if FileManager.default.fileExists(atPath: infoFileURL.path) {
                    let data = try Data(contentsOf: infoFileURL)
                    infoFiles[subdirectory.lastPathComponent] = data
                }
            }
        } catch {
            print("Error loading info files: \(error)")
        }
        
        return infoFiles
    }
}