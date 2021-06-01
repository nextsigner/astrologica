import QtQuick 2.0

Rectangle{
    id: r
    width: txtStatus.contentWidth+app.fs
    height: txtStatus.contentHeight+app.fs*0.5
    color: 'transparent'
    border.width: 1
    border.color: 'white'
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    Text {
        id: txtStatus
        text: '<b>Modo:</b> '+sweg.state
        font.pixelSize: app.fs*0.5
        color: 'white'
        anchors.centerIn: parent
    }
}
