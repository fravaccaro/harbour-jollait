import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page
{
    id: linkspage
    focus: true

    Keys.onPressed: {
        handleKeyPressed(event);
    }

    function handleKeyPressed(event) {

        if (event.key === Qt.Key_Down) {
            flickable.flick(0, - linkspage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_Up) {
            flickable.flick(0, linkspage.height);
            event.accepted = true;
        }

        if (event.key === Qt.Key_PageDown) {
            flickable.scrollToBottom();
            event.accepted = true;
        }

        if (event.key === Qt.Key_PageUp) {
            flickable.scrollToTop();
            event.accepted = true;
        }

        if (event.key === Qt.Key_B) {
            pageStack.navigateBack();
            event.accepted = true;
        }
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: qsTr("Links") }

            Item {
                height: appicon.height + Theme.paddingMedium
                width: parent.width

                Image { id: appicon; anchors.horizontalCenter: parent.horizontalCenter; source: "./appinfo.png" }
            }

            LabelText {
                text: qsTr("Join Jolla Community Italia to be updated on the last news about Jolla and Sailfish OS and get in touch with other enthusiasts, like you!")
            }

            SectionHeader { text: "Telegram" }

          ButtonLayout {

              Button {
                  text: qsTr("Channel")
                  onClicked: Qt.openUrlExternally("http://telegram.me/jollait")
              }

              Button {
                  text: qsTr("Group")
                  onClicked: Qt.openUrlExternally("https://t.me/jollaitclub")
              }
          }

              SectionHeader { text: qsTr("Social") }

            ButtonLayout {

                Button {
                    text: "Twitter"
                    onClicked: Qt.openUrlExternally("http://twitter.com/JollaIt")
                }

                Button {
                    text: "Facebook"
                    onClicked: Qt.openUrlExternally("https://www.facebook.com/JollaCommunityItalia")
                }
            }

          SectionHeader { text: qsTr("Media") }

        ButtonLayout {

            Button {
                text: "Instagram"
                onClicked: Qt.openUrlExternally("https://www.instagram.com/jollacommunityitalia/")
            }

            Button {
                text: "YouTube"
                onClicked: Qt.openUrlExternally("https://www.youtube.com/JollaCommunityItalia")
            }
        }

        Item {
            width: 1
            height: Theme.paddingLarge
        }

        }

        VerticalScrollDecorator { }
    }
}
