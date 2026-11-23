# Jolla Community Italia

Access to Jolla Community Italia, read news and discuss on the forum.

## Building on current Sailfish OS

The app uses the Gecko-based [Sailfish WebView](https://sailfishos.org/develop/docs/sailfish-components-webview/)
(`import Sailfish.WebView 1.0`) instead of the old QtWebKit `SilicaWebView`.
The build needs `pkgconfig(qt5embedwidget)`; at runtime
`sailfish-components-webview-qt5` is required, plus
`sailfish-components-webview-qt5-popups` for the `WebShareAction` used by the
share button (see `rpm/harbour-jollait.spec`). The popups package already pulls
in the Share API implementation, so no direct `declarative-transferengine-qt5`
dependency is needed.

The old `devicePixelRatioHack.js` user script was specific to QtWebKit and is no
longer loaded; the WebView engine handles device pixel ratio itself.

The WebView page is kept alive while the app is in the background instead of
being replaced by an idle page. Sailfish WebView automatically sets `active` to
false when the app is inactive or another page is shown, so the page is paused
in place and its state is preserved.

### Running from the Sailfish SDK

This is a QML-only project (`TEMPLATE = aux`), so Qt Creator cannot infer which
executable to start and shows `You need to set an executable in the custom run
configuration`. In **Projects → Build & Run → Run**, select the Sailfish custom
executable run configuration and set:

- **Executable:** `/usr/bin/sailfish-qml`
- **Command line arguments:** `harbour-jollait`

Use the **Mer/Sailfish** custom executable run configuration, not the generic
`ProjectExplorer.CustomExecutableRunConfiguration`. The generic one tries to run
the path on the SDK host and fails with `Failed to start program. Path or
permissions wrong?`. In `harbour-jollait.pro.user` the correct entry has the id
`QmakeProjectManager.MerCustomRunConfiguration:` and includes device/deploy
settings; if you edited the generic entry, delete it and add the run configuration
again while the Sailfish kit is selected, then mark it active.

This mirrors the `Exec=` line in `harbour-jollait.desktop`, which is why the app
starts normally when launched from the phone. Then deploy (RPM or rsync) and run.
Runs started this way (or from a terminal) are **not** sandboxed.

## Sailjail

`harbour-jollait.desktop` contains an `[X-Sailjail]` profile, so when the app is
launched from the application grid Sailjail wraps `sailfish-qml harbour-jollait`
and asks the user for the declared permissions:

- `Internet` — network access for the site
- `WebView` — required by the Gecko-based Sailfish WebView

`OrganizationName` and `ApplicationName` are kept as `harbour-jollait` (the values
used before sandboxing) so the QML `LocalStorage` bookmarks stay in the same
directory; using a new reverse-domain value would hide existing bookmarks.

To test the sandboxed launch manually on the device:

```
sailjail -p harbour-jollait.desktop -- /usr/bin/sailfish-qml harbour-jollait
```

## Credits

Fork of [Junat.net WebView](https://github.com/jollailija/junatnet). Thanks to jollailija.

