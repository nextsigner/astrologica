import QtQuick 2.0

Rectangle{
    id: r
    width: row.width+app.fs
    height: txtStatus.contentHeight+app.fs*0.5
    color: 'transparent'
    border.width: 1
    border.color: 'white'
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    Row{
        id: row
        anchors.centerIn: parent
        spacing: app.fs*0.25
        Text {
            id: txtStatus
            text: '<b>Modo:</b> '+sweg.state
            font.pixelSize: app.fs*0.5
            color: 'white'
        }
        Text {
            text: '<b>LT:</b> '+(xLayerTouch.visible?'SI':'NO')
            font.pixelSize: app.fs*0.5
            color: 'white'
        }
    }
}
