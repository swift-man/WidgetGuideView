import Foundation
import SwiftUI

#if canImport(UIKit) && canImport(SafariServices)
import SafariServices
import UIKit
#endif

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

  /// Returns Apple's user-facing widget guide URL for the provided locale.
  public func userGuideURL(locale: Locale = .autoupdatingCurrent) -> URL {
    Self.makeURL(
      host: "support.apple.com",
      path: "/\(locale.appleSupportIdentifier)/118610"
    )
  }

  /// Apple's WidgetKit developer documentation URL for the associated widget family.
  public var appleDeveloperURL: URL {
    switch self {
    case .homeSmall:
      return Self.makeDeveloperURL(for: "systemsmall")
    case .homeMedium:
      return Self.makeDeveloperURL(for: "systemmedium")
    case .homeLarge:
      return Self.makeDeveloperURL(for: "systemlarge")
    case .lockScreenCircular:
      return Self.makeDeveloperURL(for: "accessorycircular")
    case .lockScreenRectangular:
      return Self.makeDeveloperURL(for: "accessoryrectangular")
    }
  }

  /// Returns the guide URL for the requested destination.
  public func url(
    for destination: WidgetGuideDestination,
    locale: Locale = .autoupdatingCurrent
  ) -> URL {
    switch destination {
    case .userGuide:
      return userGuideURL(locale: locale)
    case .developerDocumentation:
      return appleDeveloperURL
    }
  }

  private static func makeDeveloperURL(for familyPath: String) -> URL {
    makeURL(
      host: "developer.apple.com",
      path: "/documentation/widgetkit/widgetfamily/\(familyPath)"
    )
  }

  private static func makeURL(host: String, path: String) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path

    guard let url = components.url else {
      return fallbackUserGuideURL
    }

    return url
  }

  private static var fallbackUserGuideURL: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "support.apple.com"
    components.path = "/en-us/118610"

    guard let url = components.url else {
      preconditionFailure("Invalid built-in WidgetGuideView fallback URL")
    }

    return url
  }
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

  /// The locale used when building Apple support URLs.
  public let locale: Locale

  /// Creates a widget guide view.
  public init(
    kind: WidgetGuideKind,
    destination: WidgetGuideDestination = .userGuide,
    locale: Locale = .autoupdatingCurrent
  ) {
    self.kind = kind
    self.destination = destination
    self.locale = locale
  }

  /// The SwiftUI body for the guide.
  public var body: some View {
    SafariView(url: guideURL)
      .id(guideURL)
      .widgetGuideIgnoresSafeArea()
  }

  private var guideURL: URL {
    kind.url(for: destination, locale: locale)
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
    let components = identifier
      .replacingOccurrences(of: "_", with: "-")
      .lowercased()
      .split(separator: "-")
      .map(String.init)

    guard let language = components.first, !language.isEmpty else {
      return nil
    }

    if let region = components.dropFirst().last(where: { component in
      component.count == 2 || component.count == 3
    }) {
      return "\(language)-\(region)"
    }

    if language == "zh" {
      if components.contains("hant") {
        return "zh-tw"
      }

      if components.contains("hans") {
        return "zh-cn"
      }
    }

    if let defaultRegion = appleSupportDefaultRegions[language] {
      return "\(language)-\(defaultRegion)"
    }

    return nil
  }

  static var appleSupportDefaultRegions: [String: String] {
    // Language-only fallbacks pick one common Apple Support region.
    // Pass an explicit region, such as pt-PT, when the distinction matters.
    [
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
  }
}
