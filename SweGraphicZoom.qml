import QtQuick 2.7
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

Item {
    id: r
    width: xApp.width*0.2
    height: width
    property alias sweg: objSweGraphinZoom
    property real zoom: 2.0
    property int lupaX: xLupa.image.x
    property int lupaY: xLupa.image.y
    //visible: false
    clip: true
    state: 'show'
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
                x:0-r.width
            }
        }
    ]
    Behavior on x{NumberAnimation{duration: 250}}
    Rectangle{
        anchors.fill: r
        color: 'black'
    }
    Item{
        id: xSwegZoom
        width: xApp.width//Screen.width
        height: xApp.height//Screen.height
        x:r.lupaX+r.width*0.5-xLupa.width*0.5//0-lupaX*r.zoom+xApp.width*(r.zoom*0.25)//-r.width*0.5
        y: r.lupaY+r.height*0.5-xLupa.height*0.5//0-lupaY*r.zoom+xApp.height*(r.zoom*0.25)//-r.width*0.5
        SweGraphic{
            id: objSweGraphinZoom
            anchors.centerIn: parent
            objHousesCircle.extraObjectName: 'zoom'
            state: sweg.state
            scale: 2.0
        }
//        MouseArea{
//            anchors.fill: parent
//            drag.target: xSwegZoom
//            drag.axis: Drag.XAndYAxis
//        }
    }
    Text {
        id: info
        text: 'S:'+objSweGraphinZoom.state+' CH:'+objSweGraphinZoom.objHousesCircle.currentHouse
        font.pixelSize: app.fs
        color: 'red'
        visible: false
    }
    Rectangle{
        anchors.fill: r
        border.width: 2
        border.color: 'white'
        color: 'transparent'
    }
}
