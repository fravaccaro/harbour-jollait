/*
  Copyright (C) 2016 jollailija
  Contact: jollailija <jollailija@gmail.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * The names of the contributors may not be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import "../components"
import "../components/dockedbar"
import QtQuick 2.1
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0

WebViewPage {
    // No IdlePage replacement is needed: WebView.active already follows
    // Qt.application.state and the WebViewPage status, so the page is paused
    // in place while the app is in the background or another page is shown.
    // Keeping this page alive preserves scroll position and page state.

    id: page

    property alias webView: webViewContainer.webView
    property real webViewBottomMargin: webView.chrome ? dockedbar.height : 0

    // Sailfish WebView has no flick(), scrollToTop() or scrollToBottom() helpers:
    // use runJavaScript() to scroll the document instead.
    function scrollBy(amount) {
        webView.runJavaScript("window.scrollBy(0, " + Math.round(amount) + "); return true;");
    }

    function scrollToTop() {
        webView.runJavaScript("window.scrollTo(0, 0); return true;");
    }

    function scrollToBottom() {
        webView.runJavaScript("window.scrollTo(0, Math.max(document.body.scrollHeight, document.documentElement.scrollHeight)); return true;");
    }

    function handleKeyPressed(event) {
        if (event.key === Qt.Key_Down) {
            scrollBy(page.height);
            event.accepted = true;
        }
        if (event.key === Qt.Key_Up) {
            scrollBy(-page.height);
            event.accepted = true;
        }
        if (event.key === Qt.Key_PageDown) {
            scrollToBottom();
            event.accepted = true;
        }
        if (event.key === Qt.Key_PageUp) {
            scrollToTop();
            event.accepted = true;
        }
        if (event.key === Qt.Key_B) {
            webView.goBack();
            event.accepted = true;
        }
        if (event.key === Qt.Key_F) {
            webView.goForward();
            event.accepted = true;
        }
        if (event.key === Qt.Key_H) {
            webView.url = "https://www.jollacommunity.it";
            event.accepted = true;
        }
        if (event.key === Qt.Key_R) {
            webView.reload();
            event.accepted = true;
        }
    }

    focus: true
    Keys.onPressed: {
        handleKeyPressed(event);
    }

    // just don't. I know it's wrong, but the freaking bug won't die!
    BookmarkPage {
        id: bookmarkPage
    }

    // WebViewFlickable provides the Silica flickable required by PullDownMenu.
    WebViewFlickable {
        id: webViewContainer

        anchors.fill: parent
        anchors.bottomMargin: webViewBottomMargin

        Binding {
            target: webViewContainer.webView
            property: "url"
            value: "https://www.jollacommunity.it"
        }

        Binding {
            target: webViewContainer.webView
            property: "chromeGestureEnabled"
            value: true
        }

        Binding {
            target: webViewContainer.webView
            property: "chromeGestureThreshold"
            value: Theme.paddingLarge
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("./AboutPage.qml"))
            }

            MenuItem {
                text: qsTr("Useful links")
                onClicked: pageStack.push(Qt.resolvedUrl("./LinksPage.qml"))
            }

            MenuItem {
                text: qsTr("Open in browser")
                onClicked: Qt.openUrlExternally(webView.url)
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: webView.reload()
            }

        }

    }

    DockedBar {
        id: dockedbar

        property bool shown: webView.chrome
        property real slideOffset: shown ? 0 : height

        opacity: shown ? 1 : 0
        visible: opacity > 0

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        transform: Translate {
            y: dockedbar.slideOffset
        }

        Behavior on slideOffset {
            NumberAnimation {
                duration: 220
                easing.type: Easing.InOutQuad
            }

        }

        Behavior on opacity {
            FadeAnimation {
                duration: 220
            }

        }

    }

    Behavior on webViewBottomMargin {
        NumberAnimation {
            duration: 220
            easing.type: Easing.InOutQuad
        }

    }

}
