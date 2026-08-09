import Foundation
import XCTest
@testable import WidgetGuideView

#if canImport(UIKit)
import UIKit
#endif

final class WidgetGuideKindTests: XCTestCase {
  func testUserGuideURLNormalizesLocaleIdentifiers() {
    let cases = [
      ("en_US", "https://support.apple.com/en-us/118610"),
      ("en-US-u-ca-gregory", "https://support.apple.com/en-us/118610"),
      ("en_GB", "https://support.apple.com/en-gb/118610"),
      ("en_DE", "https://support.apple.com/en-us/118610"),
      ("ko", "https://support.apple.com/ko-kr/118610"),
      ("ko_US", "https://support.apple.com/ko-kr/118610"),
      ("fr_CA", "https://support.apple.com/fr-ca/118610"),
      ("hi", "https://support.apple.com/hi-in/118610"),
      ("hi_IN", "https://support.apple.com/hi-in/118610"),
      ("hr", "https://support.apple.com/hr-hr/118610"),
      ("ms_MY", "https://support.apple.com/ms-my/118610"),
      ("zh-Hant", "https://support.apple.com/zh-tw/118610"),
      ("zh_Hant_TW", "https://support.apple.com/zh-tw/118610"),
      ("zh_Hant_HK", "https://support.apple.com/zh-hk/118610"),
      ("es-419", "https://support.apple.com/es-es/118610"),
      ("en-001", "https://support.apple.com/en-us/118610"),
      ("nb_NO", "https://support.apple.com/no-no/118610"),
      ("iw_IL", "https://support.apple.com/he-il/118610"),
      ("in_ID", "https://support.apple.com/id-id/118610"),
      ("pt", "https://support.apple.com/pt-br/118610")
    ]

    for (identifier, expectedURL) in cases {
      let url = WidgetGuideKind.homeSmall.userGuideURL(
        platform: .iPhone,
        locale: Locale(identifier: identifier)
      )

      XCTAssertEqual(url.absoluteString, expectedURL, identifier)
    }
  }

  func testUserGuideURLMatchesSelectedPlatformForEveryWidgetKind() {
    let locale = Locale(identifier: "ko_KR")

    for kind in WidgetGuideKind.allCases {
      XCTAssertEqual(
        kind.userGuideURL(platform: .iPhone, locale: locale).absoluteString,
        "https://support.apple.com/ko-kr/118610"
      )
      XCTAssertEqual(
        kind.userGuideURL(platform: .iPad, locale: locale).absoluteString,
        "https://support.apple.com/ko-kr/guide/ipad/ipadb0de8630/ipados"
      )
      XCTAssertEqual(
        kind.url(
          for: .userGuide,
          platform: .iPad,
          locale: locale
        ).absoluteString,
        "https://support.apple.com/ko-kr/guide/ipad/ipadb0de8630/ipados"
      )
    }
  }

  @MainActor
  func testAutomaticUserGuideURLMatchesCurrentDevice() {
    #if canImport(UIKit)
    let expectedURL = UIDevice.current.userInterfaceIdiom == .pad
      ? "https://support.apple.com/en-us/guide/ipad/ipadb0de8630/ipados"
      : "https://support.apple.com/en-us/118610"
    #else
    let expectedURL = "https://support.apple.com/en-us/118610"
    #endif

    let url = WidgetGuideKind.homeSmall.userGuideURL(
      locale: Locale(identifier: "en_US")
    )

    XCTAssertEqual(url.absoluteString, expectedURL)
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
        kind.url(
          for: .developerDocumentation,
          platform: .iPhone
        ).absoluteString,
        developerURL
      )
    }
  }
}
