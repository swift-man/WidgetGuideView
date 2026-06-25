# ``WidgetGuideView``

Show Apple's official widget help pages from a SwiftUI app.

## Overview

`WidgetGuideView` wraps `SFSafariViewController` in SwiftUI and opens either Apple's user-facing widget guide or the WidgetKit developer documentation for a supported widget family.

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

## Topics

### Showing Guides

- ``WidgetGuideView``
- ``SafariView``

### Choosing Guide Content

- ``WidgetGuideKind``
- ``WidgetGuideDestination``

