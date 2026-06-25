import Foundation
import XCTest
@testable import WidgetGuideView

final class WidgetGuideKindTests: XCTestCase {
  func testUserGuideURLNormalizesLocaleIdentifiers() {
    let cases = [
      ("en_US", "https://support.apple.com/en-us/118610"),
      ("en-US-u-ca-gregory", "https://support.apple.com/en-us/118610"),
      ("ko", "https://support.apple.com/ko-kr/118610"),
      ("zh-Hant", "https://support.apple.com/zh-tw/118610"),
      ("zh_Hant_TW", "https://support.apple.com/zh-tw/118610"),
      ("es-419", "https://support.apple.com/es-es/118610"),
      ("en-001", "https://support.apple.com/en-us/118610"),
      ("pt", "https://support.apple.com/pt-br/118610")
    ]

    for (identifier, expectedURL) in cases {
      let url = WidgetGuideKind.homeSmall.userGuideURL(
        locale: Locale(identifier: identifier)
      )

      XCTAssertEqual(url.absoluteString, expectedURL, identifier)
    }
  }

  func testWidgetFamiliesMatchDeveloperDocumentationURLs() {
    let cases: [(WidgetGuideKind, String, String)] = [
      (
        .homeSmall,
        "systemSmall",
        "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemsmall"
      ),
      (
        .homeMedium,
        "systemMedium",
        "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemmedium"
      ),
      (
        .homeLarge,
        "systemLarge",
        "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemlarge"
      ),
      (
        .lockScreenCircular,
        "accessoryCircular",
        "https://developer.apple.com/documentation/widgetkit/widgetfamily/accessorycircular"
      ),
      (
        .lockScreenRectangular,
        "accessoryRectangular",
        "https://developer.apple.com/documentation/widgetkit/widgetfamily/accessoryrectangular"
      )
    ]

    for (kind, family, developerURL) in cases {
      XCTAssertEqual(kind.widgetFamily, family)
      XCTAssertEqual(kind.appleDeveloperURL.absoluteString, developerURL)
      XCTAssertEqual(
        kind.url(for: .developerDocumentation).absoluteString,
        developerURL
      )
    }
  }
}
