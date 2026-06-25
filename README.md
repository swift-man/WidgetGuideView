# WidgetGuideView

![Swift](https://img.shields.io/badge/Swift-5.9-F05138.svg?style=flat-square&logo=Swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-0D96F6.svg?style=flat-square&logo=Swift&logoColor=white)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange?style=flat-square)
![Platform](https://img.shields.io/badge/iOS-v13.0-yellow?style=flat-square)
![DocC](https://img.shields.io/badge/DocC-ready-1177AA?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-black?style=flat-square)

`WidgetGuideView`는 Apple 공식 위젯 가이드와 WidgetKit 개발자 문서를 앱 안에서 `SFSafariViewController`로 보여주기 위한 Swift Package입니다.

## Requirements

- iOS 13.0+
- Swift 5.9+

## Installation

Xcode에서 `File > Add Package Dependencies...`를 선택한 뒤 이 저장소 URL을 추가합니다.

## Documentation

DocC 문서는 `main` 브랜치에 push되거나 GitHub Actions에서 `Deploy DocC` workflow를 수동 실행하면 `swift-man/docs` 저장소의 `WidgetGuideView/` 경로로 배포됩니다.

배포에는 `DOCS_DEPLOY_KEY` secret이 필요합니다.

## Usage

```swift
import SwiftUI
import WidgetGuideView

struct ContentView: View {
  var body: some View {
    WidgetGuideView(kind: .homeSmall)
  }
}
```

개발자 문서를 보여주려면 `destination`을 지정합니다.

```swift
WidgetGuideView(
  kind: .lockScreenRectangular,
  destination: .developerDocumentation
)
```

특정 locale의 Apple 지원 문서를 열어야 한다면 `locale`을 전달합니다.

```swift
WidgetGuideView(
  kind: .homeMedium,
  locale: Locale(identifier: "ko_KR")
)
```

## Supported Widget Guides

| Kind | WidgetKit family | User guide | Developer documentation |
| --- | --- | --- | --- |
| `homeSmall` | `systemSmall` | `https://support.apple.com/{locale}/118610` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/systemsmall` |
| `homeMedium` | `systemMedium` | `https://support.apple.com/{locale}/118610` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/systemmedium` |
| `homeLarge` | `systemLarge` | `https://support.apple.com/{locale}/118610` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/systemlarge` |
| `lockScreenCircular` | `accessoryCircular` | `https://support.apple.com/{locale}/118610` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/accessorycircular` |
| `lockScreenRectangular` | `accessoryRectangular` | `https://support.apple.com/{locale}/118610` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/accessoryrectangular` |
