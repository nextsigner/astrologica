import QtQuick 2.0

Rectangle{
    id: r
    width: row.width+app.fs
    height: r.parent.height
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
            text: '<b>Mod:</b> '+app.mod
            font.pixelSize: r.height*0.5
            color: 'white'
        }
        Text {
            id: txtStatus
            text: '<b>SWEG:</b> '+sweg.state
            font.pixelSize: r.height*0.5
            color: 'white'
        }
        Text {
            text: '<b>LT:</b> '+(xLayerTouch.visible?'SI':'NO')
            font.pixelSize: app.fs*0.5
            color: 'white'
        }
    }
}
