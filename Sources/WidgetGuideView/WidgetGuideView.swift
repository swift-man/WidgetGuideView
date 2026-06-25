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
    URL(string: "https://support.apple.com/\(locale.appleSupportIdentifier)/118610")!
  }

  /// Apple's WidgetKit developer documentation URL for the associated widget family.
  public var appleDeveloperURL: URL {
    switch self {
    case .homeSmall:
      return URL(string: "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemsmall")!
    case .homeMedium:
      return URL(string: "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemmedium")!
    case .homeLarge:
      return URL(string: "https://developer.apple.com/documentation/widgetkit/widgetfamily/systemlarge")!
    case .lockScreenCircular:
      return URL(string: "https://developer.apple.com/documentation/widgetkit/widgetfamily/accessorycircular")!
    case .lockScreenRectangular:
      return URL(string: "https://developer.apple.com/documentation/widgetkit/widgetfamily/accessoryrectangular")!
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
    SafariView(url: kind.url(for: destination, locale: locale))
      .edgesIgnoringSafeArea(.all)
  }
}

/// A SwiftUI wrapper around `SFSafariViewController`.
public struct SafariView: UIViewControllerRepresentable {
  /// The URL to load.
  public let url: URL

  /// Creates a Safari view for the provided URL.
  public init(url: URL) {
    self.url = url
  }

  /// Creates the underlying Safari view controller.
  public func makeUIViewController(context: Context) -> SFSafariViewController {
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
  public func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: Context
  ) {}
}
#endif

private extension Locale {
  var appleSupportIdentifier: String {
    let candidates = [identifier] + Locale.preferredLanguages

    for candidate in candidates {
      if let identifier = Self.normalizedAppleSupportIdentifier(from: candidate) {
        return identifier
      }
    }

    return "en-us"
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

    guard let region = components.dropFirst().last(where: { component in
      component.count == 2 || component.count == 3
    }) else {
      return nil
    }

    return "\(language)-\(region)"
  }
}
