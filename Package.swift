// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "WidgetGuideView",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "WidgetGuideView",
      targets: ["WidgetGuideView"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  targets: [
    .target(name: "WidgetGuideView")
  ],
  swiftLanguageVersions: [.v5]
)
