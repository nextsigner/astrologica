import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    signal move(int px, int py)
    MouseArea{
        anchors.fill: r
        onClicked: r.move(mouseX, mouseY)
        onDoubleClicked: {
            r.visible=false
            tShow.restart()
        }
    }
    Timer{
        id: tShow
        running: false
        repeat: false
        interval: 1500
        onTriggered: r.visible=true
    }
}
