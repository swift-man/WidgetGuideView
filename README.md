# WidgetGuideView

![Swift](https://img.shields.io/badge/Swift-5.9-F05138.svg?style=flat-square&logo=Swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-compatible-0D96F6.svg?style=flat-square&logo=Swift&logoColor=white)
![Version](https://img.shields.io/badge/Version-0.1.1-1177AA.svg?style=flat-square)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange?style=flat-square)
![Platform](https://img.shields.io/badge/iOS-v13.0-yellow?style=flat-square)
![DocC](https://img.shields.io/badge/DocC-ready-1177AA?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-black?style=flat-square)

`WidgetGuideView`는 Apple 공식 위젯 가이드와 WidgetKit 개발자 문서를 앱 안에서 `SFSafariViewController`로 보여주기 위한 Swift Package입니다.

사용자 가이드는 실행 기기를 자동으로 감지하여 iPhone 또는 iPad용 Apple 공식 문서를 엽니다.

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

자동 감지 대신 특정 플랫폼의 가이드를 열려면 `platform`을 지정합니다.

```swift
WidgetGuideView(
  kind: .homeLarge,
  platform: .iPad,
  locale: Locale(identifier: "ko_KR")
)
```

## User Guide Platforms

| Platform | User guide |
| --- | --- |
| `automatic` | 실행 기기에 맞는 iPhone 또는 iPad 가이드 |
| `iPhone` | `https://support.apple.com/{locale}/118610` |
| `iPad` | `https://support.apple.com/{locale}/guide/ipad/ipadb0de8630/ipados` |

## Supported Widget Guides

Apple의 사용자 가이드는 위젯 크기별로 나뉘지 않습니다. 아래 5개 타입은 선택된 플랫폼의 공통 사용자 가이드를 사용하고, 개발자 문서만 WidgetKit family별로 구분합니다.

| Kind | WidgetKit family | Developer documentation |
| --- | --- | --- |
| `homeSmall` | `systemSmall` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/systemsmall` |
| `homeMedium` | `systemMedium` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/systemmedium` |
| `homeLarge` | `systemLarge` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/systemlarge` |
| `lockScreenCircular` | `accessoryCircular` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/accessorycircular` |
| `lockScreenRectangular` | `accessoryRectangular` | `https://developer.apple.com/documentation/widgetkit/widgetfamily/accessoryrectangular` |
