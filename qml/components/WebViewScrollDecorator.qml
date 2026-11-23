import QtQuick 2.0
import Sailfish.Silica 1.0

// The Gecko WebView scrolls internally, so Silica's VerticalScrollDecorator
// (which follows a SilicaFlickable's contentY) cannot track it. This decorator
// is driven by the WebView's own verticalScrollDecorator data instead.
Item {
    id: decorator

    property var webView: null

    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: Theme.paddingMedium

    opacity: webView && webView.verticalScrollDecorator && webView.verticalScrollDecorator.moving ? 0.75 : 0
    visible: opacity > 0

    Behavior on opacity {
        FadeAnimation { duration: 200 }
    }

    readonly property real viewportScale: webView && webView.viewportHeight > 0
                                          ? webView.height / webView.viewportHeight
                                          : 1

    Rectangle {
        id: handle

        anchors.right: parent.right
        anchors.rightMargin: 1
        width: 3
        radius: width / 2
        color: Theme.highlightColor

        height: {
            if (!webView || !webView.verticalScrollDecorator)
                return 0
            return Math.max(Theme.paddingMedium,
                            Math.min(decorator.height,
                                     webView.verticalScrollDecorator.size * decorator.viewportScale))
        }

        y: {
            if (!webView || !webView.verticalScrollDecorator)
                return 0
            var maxY = Math.max(0, decorator.height - handle.height)
            return Math.max(0, Math.min(maxY,
                                        webView.verticalScrollDecorator.position * decorator.viewportScale))
        }
    }
}
