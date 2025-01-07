//
//  AdamantWalletsAssetsBundleFinder.swift
//  AdamantWalletsAssets
//
//  Created by Владимир Клевцов on 7.1.25..
//
import Foundation

extension Foundation.Bundle {
    public static let adamantWalletsAssets: Bundle = {
        let bundleName = "AdamantWalletsAssets"

        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: AdamantWalletsAssetsBundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }()
}

private class AdamantWalletsAssetsBundleFinder {}
