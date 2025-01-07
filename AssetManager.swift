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
    var blockchainIndex = [String: [String: Any]]()
    
    guard let generalResourceURL = Bundle.module.url(forResource: "general", withExtension: nil),
          let blockchainsResourceURL = Bundle.module.url(forResource: "blockchains", withExtension: nil) else {
      print("Failed to find 'general' or 'blockchains' folders.")
      return []
    }
    
    do {
      let blockchainsEnumerator = FileManager.default.enumerator(at: blockchainsResourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
      
      while let blockchainFileURL = blockchainsEnumerator?.nextObject() as? URL {
        if blockchainFileURL.lastPathComponent == "info.json" {
          do {
            let blockchainData = try Data(contentsOf: blockchainFileURL)
            if let blockchainJson = try JSONSerialization.jsonObject(with: blockchainData, options: []) as? [String: Any],
               let symbol = blockchainJson["symbol"] as? String {
              blockchainIndex[symbol.lowercased()] = blockchainJson
            }
          } catch {
            print("Failed to parse JSON from blockchains file at \(blockchainFileURL.path): \(error)")
          }
        }
      }
    }
    
    do {
      let generalEnumerator = FileManager.default.enumerator(at: generalResourceURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
      
      while let generalFileURL = generalEnumerator?.nextObject() as? URL {
        if generalFileURL.lastPathComponent == "info.json" {
          do {
            let generalData = try Data(contentsOf: generalFileURL)
            var generalJson = try JSONSerialization.jsonObject(with: generalData, options: []) as? [String: Any]
            
            if let symbol = generalJson?["symbol"] as? String,
               let blockchainJson = blockchainIndex[symbol.lowercased()] {
              generalJson?.merge(blockchainJson) { (_, blockchainValue) in
                return blockchainValue
              }
            }
            
            if let mergedJson = generalJson {
              jsonFiles.append(mergedJson)
            }
          } catch {
            print("Failed to parse JSON from general file at \(generalFileURL.path): \(error)")
          }
        }
      }
    }
    
    for (symbol, blockchainJson) in blockchainIndex {
      if !jsonFiles.contains(where: { ($0 as? [String: Any])?["symbol"] as? String == symbol.uppercased() }) {
        jsonFiles.append(blockchainJson)
      }
    }
    
    return jsonFiles
  }
}
