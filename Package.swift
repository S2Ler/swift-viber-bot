// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-viber-bot",
  platforms: [
      .macOS(.v10_15),
  ],
  products: [
    .library(name: "ViberBot", targets: ["ViberBot"]),
    .library(name: "ViberDefaultWebHook", targets: ["ViberDefaultWebHook"]),
    .library(name: "ViberBotApi", targets: ["ViberBotApi"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/S2Ler/ExpressSwift.git",
      .upToNextMinor(from: "0.1.0")
    ),
    .package(
      url: "https://github.com/S2Ler/Networker.git",
      .branch("master")
    ),
    .package(
      url: "https://github.com/apple/swift-log",
      .upToNextMajor(from: "1.4.0")
    ),
  ],
  targets: [
    .target(
      name: "ViberBot",
      dependencies: [
        "ViberWebHook",
        "ViberDefaultWebHook",
        "ViberBotApi",
        .product(name: "Logging", package: "swift-log"),
        .product(name: "Networker", package: "Networker"),
      ]
    ),
    .target(
      name: "ViberWebHook"
    ),
    .target(
      name: "ViberBotApi",
      dependencies: [
        "ViberBotDataModels",
        .product(name: "Networker", package: "Networker"),
      ]
    ),
    .target(
      name: "ViberDefaultWebHook",
      dependencies: [
        "ViberWebHook",
        .product(name: "ExpressSwift", package: "ExpressSwift"),
      ]
    ),
    .target(name: "ViberBotDataModels"),
    .testTarget(
      name: "ViberBotTests",
      dependencies: ["ViberBot"]),
  ]
)
