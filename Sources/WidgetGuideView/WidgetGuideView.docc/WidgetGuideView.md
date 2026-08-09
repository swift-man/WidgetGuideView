# ``WidgetGuideView``

Show Apple's official widget help pages from a SwiftUI app.

## Overview

`WidgetGuideView` wraps `SFSafariViewController` in SwiftUI and opens either Apple's user-facing widget guide or the WidgetKit developer documentation for a supported widget family. The user guide automatically matches the current iPhone or iPad by default.

Use ``WidgetGuideKind`` to choose the widget size or Lock Screen widget shape, then present ``WidgetGuideView`` from your app.

```swift
import SwiftUI
import WidgetGuideView

struct ContentView: View {
  var body: some View {
    WidgetGuideView(kind: .homeSmall)
  }
}
```

To open developer documentation instead of the user guide, pass ``WidgetGuideDestination/developerDocumentation``.

```swift
WidgetGuideView(
  kind: .lockScreenRectangular,
  destination: .developerDocumentation
)
```

To override automatic platform detection, pass a ``WidgetGuidePlatform`` value.

```swift
WidgetGuideView(
  kind: .homeLarge,
  platform: .iPad,
  locale: Locale(identifier: "ko_KR")
)
```

## Topics

### Showing Guides

- ``WidgetGuideView``

### Choosing Guide Content

- ``WidgetGuideKind``
- ``WidgetGuidePlatform``
- ``WidgetGuideDestination``
