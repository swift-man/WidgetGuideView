import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(SafariServices)
import SafariServices
#endif

/// The Apple platform whose user-facing widget guide should be shown.
public enum WidgetGuidePlatform: Sendable {
  /// Selects the guide for the current device, defaulting to iPhone off iOS.
  case automatic

  /// Apple's iPhone widget guide.
  case iPhone

  /// Apple's iPad widget guide.
  case iPad

  fileprivate var resolved: ResolvedWidgetGuidePlatform {
    switch self {
    case .automatic:
      #if canImport(UIKit)
      return UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
      #else
      return .iPhone
      #endif
    case .iPhone:
      return .iPhone
    case .iPad:
      return .iPad
    }
  }
}

private enum ResolvedWidgetGuidePlatform {
  case iPhone
  case iPad

  func supportPath(localeIdentifier: String) -> String {
    switch self {
    case .iPhone:
      return "/\(localeIdentifier)/118610"
    case .iPad:
      return "/\(localeIdentifier)/guide/ipad/ipadb0de8630/ipados"
    }
  }
}

/// A widget guide that can be opened from the app.
public enum WidgetGuideKind: CaseIterable, Identifiable, Sendable {
  /// A small Home Screen widget using WidgetKit's `systemSmall` family.
  case homeSmall

  /// A medium Home Screen widget using WidgetKit's `systemMedium` family.
  case homeMedium

  /// A large Home Screen widget using WidgetKit's `systemLarge` family.
  case homeLarge

  /// A circular Lock Screen widget using WidgetKit's `accessoryCircular` family.
  case lockScreenCircular

  /// A rectangular Lock Screen widget using WidgetKit's `accessoryRectangular` family.
  case lockScreenRectangular

  /// The stable identity for SwiftUI lists and pickers.
  public var id: Self { self }

  /// A display title for the guide.
  public var title: String {
    switch self {
    case .homeSmall:
      return "Small Widget"
    case .homeMedium:
      return "Medium Widget"
    case .homeLarge:
      return "Large Widget"
    case .lockScreenCircular:
      return "Lock Screen Small Widget"
    case .lockScreenRectangular:
      return "Lock Screen Rectangular Widget"
    }
  }

  /// The WidgetKit family name associated with this guide.
  public var widgetFamily: String {
    switch self {
    case .homeSmall:
      return "systemSmall"
    case .homeMedium:
      return "systemMedium"
    case .homeLarge:
      return "systemLarge"
    case .lockScreenCircular:
      return "accessoryCircular"
    case .lockScreenRectangular:
      return "accessoryRectangular"
    }
  }

  /// Returns Apple's user-facing widget guide URL for the provided platform and locale.
  public func userGuideURL(
    platform: WidgetGuidePlatform = .automatic,
    locale: Locale = .autoupdatingCurrent
  ) -> URL {
    let resolvedPlatform = platform.resolved

    return Self.makeURL(
      host: "support.apple.com",
      path: resolvedPlatform.supportPath(
        localeIdentifier: locale.appleSupportIdentifier
      ),
      fallback: Self.fallbackUserGuideURL(for: resolvedPlatform)
    )
  }

  /// Apple's WidgetKit developer documentation URL for the associated widget family.
  public var appleDeveloperURL: URL {
    Self.makeDeveloperURL(for: widgetFamily.lowercased())
  }

  /// Returns the guide URL for the requested destination.
  public func url(
    for destination: WidgetGuideDestination,
    platform: WidgetGuidePlatform = .automatic,
    locale: Locale = .autoupdatingCurrent
  ) -> URL {
    switch destination {
    case .userGuide:
      return userGuideURL(platform: platform, locale: locale)
    case .developerDocumentation:
      return appleDeveloperURL
    }
  }

  private static func makeDeveloperURL(for familyPath: String) -> URL {
    makeURL(
      host: "developer.apple.com",
      path: "/documentation/widgetkit/widgetfamily/\(familyPath)",
      fallback: fallbackDeveloperDocumentationURL
    )
  }

  private static func makeURL(
    host: String,
    path: String,
    fallback: URL
  ) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path

    guard let url = components.url else {
      return fallback
    }

    return url
  }

  private static func fallbackUserGuideURL(
    for platform: ResolvedWidgetGuidePlatform
  ) -> URL {
    switch platform {
    case .iPhone:
      return fallbackIPhoneUserGuideURL
    case .iPad:
      return fallbackIPadUserGuideURL
    }
  }

  private static let fallbackIPhoneUserGuideURL: URL = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "support.apple.com"
    components.path = "/en-us/118610"

    guard let url = components.url else {
      preconditionFailure("Invalid built-in WidgetGuideView fallback URL")
    }

    return url
  }()

  private static let fallbackIPadUserGuideURL: URL = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "support.apple.com"
    components.path = "/en-us/guide/ipad/ipadb0de8630/ipados"

    guard let url = components.url else {
      preconditionFailure("Invalid built-in WidgetGuideView iPad fallback URL")
    }

    return url
  }()

  private static let fallbackDeveloperDocumentationURL: URL = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "developer.apple.com"
    components.path = "/documentation/widgetkit"

    guard let url = components.url else {
      preconditionFailure("Invalid built-in WidgetGuideView developer fallback URL")
    }

    return url
  }()
}

/// The Apple documentation destination to open.
public enum WidgetGuideDestination: Sendable {
  /// Apple's user-facing support guide for adding and managing widgets.
  case userGuide

  /// Apple's developer documentation for the WidgetKit family.
  case developerDocumentation
}

#if canImport(UIKit) && canImport(SafariServices)
/// A SwiftUI view that opens an Apple widget guide using `SFSafariViewController`.
public struct WidgetGuideView: View {
  /// The widget guide to show.
  public let kind: WidgetGuideKind

  /// The documentation destination to open.
  public let destination: WidgetGuideDestination

  /// The platform used when selecting Apple's user-facing guide.
  public let platform: WidgetGuidePlatform

  /// The locale used when building Apple support URLs.
  public let locale: Locale

  /// Creates a widget guide view.
  public init(
    kind: WidgetGuideKind,
    destination: WidgetGuideDestination = .userGuide,
    platform: WidgetGuidePlatform = .automatic,
    locale: Locale = .autoupdatingCurrent
  ) {
    self.kind = kind
    self.destination = destination
    self.platform = platform
    self.locale = locale
  }

  /// The SwiftUI body for the guide.
  public var body: some View {
    SafariView(url: guideURL)
      .id(guideURL)
      .widgetGuideIgnoresSafeArea()
  }

  private var guideURL: URL {
    kind.url(for: destination, platform: platform, locale: locale)
  }
}

/// A SwiftUI wrapper around `SFSafariViewController`.
struct SafariView: UIViewControllerRepresentable {
  /// The URL to load.
  let url: URL

  /// Creates a Safari view for the provided URL.
  init(url: URL) {
    self.url = url
  }

  /// Creates the underlying Safari view controller.
  func makeUIViewController(context: Context) -> SFSafariViewController {
    let configuration = SFSafariViewController.Configuration()
    configuration.entersReaderIfAvailable = false
    configuration.barCollapsingEnabled = true

    let viewController = SFSafariViewController(
      url: url,
      configuration: configuration
    )
    viewController.dismissButtonStyle = .close
    return viewController
  }

  /// Updates the underlying Safari view controller.
  ///
  /// `SFSafariViewController` does not expose an API for replacing the loaded URL.
  /// Recreate the SwiftUI view with a new identity when the URL changes.
  func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: Context
  ) {}
}

private extension View {
  @ViewBuilder
  func widgetGuideIgnoresSafeArea() -> some View {
    if #available(iOS 14.0, *) {
      ignoresSafeArea()
    } else {
      edgesIgnoringSafeArea(.all)
    }
  }
}
#endif

private extension Locale {
  var appleSupportIdentifier: String {
    Self.normalizedAppleSupportIdentifier(from: identifier) ?? "en-us"
  }

  static func normalizedAppleSupportIdentifier(from identifier: String) -> String? {
    let components = NSLocale.components(fromLocaleIdentifier: identifier)

    guard let languageCode = components[NSLocale.Key.languageCode.rawValue]?.lowercased(),
          !languageCode.isEmpty
    else {
      return nil
    }

    let language = appleSupportLanguageCode(for: languageCode)

    if let region = components[NSLocale.Key.countryCode.rawValue]?.lowercased(),
       isAppleSupportRegionCode(region),
       supportsAppleSupportLocale(language: language, region: region)
    {
      return "\(language)-\(region)"
    }

    if language == "zh" {
      let script = components[NSLocale.Key.scriptCode.rawValue]?.lowercased()

      if script == "hant" {
        return "zh-tw"
      }

      if script == "hans" {
        return "zh-cn"
      }
    }

    if let defaultRegion = appleSupportDefaultRegions[language] {
      return "\(language)-\(defaultRegion)"
    }

    return nil
  }

  static func isAppleSupportRegionCode(_ region: String) -> Bool {
    region.count == 2 && region.utf8.allSatisfy {
      $0 >= 0x61 && $0 <= 0x7A
    }
  }

  static func appleSupportLanguageCode(for language: String) -> String {
    switch language {
    case "nb", "nn":
      return "no"
    case "iw":
      return "he"
    case "in":
      return "id"
    default:
      return language
    }
  }

  static func supportsAppleSupportLocale(language: String, region: String) -> Bool {
    guard let supportedRegions = appleSupportSupportedRegionsByLanguage[language] else {
      return false
    }

    return supportedRegions.contains(region)
  }

  // Language-only fallbacks pick one common Apple Support region.
  // Pass an explicit region, such as pt-PT, when the distinction matters.
  static let appleSupportDefaultRegions: [String: String] = [
    "ar": "ae",
    "cs": "cz",
    "da": "dk",
    "de": "de",
    "el": "gr",
    "en": "us",
    "es": "es",
    "fi": "fi",
    "fr": "fr",
    "he": "il",
    "hi": "in",
    "hr": "hr",
    "hu": "hu",
    "id": "id",
    "it": "it",
    "ja": "jp",
    "ko": "kr",
    "ms": "my",
    "nl": "nl",
    "no": "no",
    "pl": "pl",
    "pt": "br",
    "ro": "ro",
    "ru": "ru",
    "sk": "sk",
    "sv": "se",
    "th": "th",
    "tr": "tr",
    "uk": "ua",
    "vi": "vn",
    "zh": "cn"
  ]

  static let appleSupportSupportedRegionsByLanguage: [String: Set<String>] = [
    "ar": ["ae", "bh", "eg", "jo", "kw", "om", "qa", "sa"],
    "cs": ["cz"],
    "da": ["dk"],
    "de": ["at", "ch", "de", "li", "lu"],
    "el": ["cy", "gr"],
    "en": [
      "ae", "al", "am", "au", "az", "bh", "bn", "bw", "by", "ca", "eg",
      "gb", "ge", "gu", "gw", "hk", "ie", "il", "in", "is", "jo", "ke",
      "kg", "kw", "kz", "lb", "lk", "md", "me", "mk", "mn", "mo", "mt",
      "my", "mz", "ng", "nz", "om", "ph", "qa", "sa", "sg", "tj", "tm",
      "ug", "us", "uz", "vn", "za"
    ],
    "es": ["cl", "co", "es", "mx", "us"],
    "fi": ["fi"],
    "fr": [
      "be", "ca", "cf", "ch", "ci", "cm", "fr", "gn", "gq", "lu", "ma",
      "mg", "ml", "mu", "ne", "sn", "tn"
    ],
    "he": ["il"],
    "hi": ["in"],
    "hr": ["hr"],
    "hu": ["hu"],
    "id": ["id"],
    "it": ["it"],
    "ja": ["jp"],
    "ko": ["kr"],
    "ms": ["my"],
    "nl": ["be", "nl"],
    "no": ["no"],
    "pl": ["pl"],
    "pt": ["br", "pt"],
    "ro": ["md", "ro"],
    "ru": ["ru"],
    "sk": ["sk"],
    "sv": ["se"],
    "th": ["th"],
    "tr": ["tr"],
    "uk": ["ua"],
    "vi": ["vn"],
    "zh": ["cn", "hk", "mo", "tw"]
  ]
}
