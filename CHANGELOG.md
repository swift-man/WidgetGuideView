# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2026-08-09

### Added

- Automatic iPhone and iPad user guide selection based on the current device.
- Explicit platform overrides for apps that need to choose a specific Apple user guide.

### Fixed

- Official URL validation now covers both iPhone and iPad widget guides.
- Apple human-verification responses no longer report valid support pages as broken links.
- Canonical Apple redirects for localized iPad guides are accepted when they preserve the guide identifier.

## [0.1.0] - 2026-07-07

### Added

- Initial Swift Package Manager package for WidgetGuideView.
- SwiftUI WidgetGuideView backed by SFSafariViewController.
- Widget guide support for home screen small, medium, large, lock screen circular, and lock screen rectangular families.
- Locale-aware Apple Support guide URLs and WidgetKit developer documentation URLs.
- DocC documentation deployment workflow for the docs repository.
- Scheduled GitHub Actions URL validation for official Apple guide links.
