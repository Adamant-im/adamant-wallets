// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "AdamantWalletsAssets",
  platforms: [
    .iOS(.v15), .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "AdamantWalletsAssets",
      targets: ["AdamantWalletsAssets"]
    ),
  ],
  targets: [
    .target(
      name: "AdamantWalletsAssets",
      path: ".",
      exclude: ["README"]
    )
  ]
)
