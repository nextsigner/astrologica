import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    visible: apps.lt
    signal move(int px, int py)
    MouseArea{
        //anchors.fill: r
        width: sweg.width
        height: r.height
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: r.move(mouseX+((r.width-sweg.width)*0.5), mouseY)
        onDoubleClicked: {
            r.visible=false
            tShow.restart()
        }
        Rectangle{
            anchors.fill: parent
            color: 'red'
            opacity: 0.5
            visible: false
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
