import QtQuick 2.7
import QtQuick.Controls 2.0
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:r.width
            }
        }
    ]
    Behavior on x{enabled: app.enableAn;NumberAnimation{duration: app.msDesDuration}}
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        TextArea{
            width: r.width
            height: r.height
            font.pixelSize: app.fs*0.5
            color: 'white'
            wrapMode: Text.WordWrap
        }
    }
//    Rectangle{
//        anchors.fill: r
//    }

}
