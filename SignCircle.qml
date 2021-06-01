import QtQuick 2.0

Item {
    id: r
    property int f: 0
    property int w: app.fs
    property bool v: false
    property bool showBorder: false
    property int rot: 0
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                width: sweg.width-app.fs
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.width-app.fs*5
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: sweg.width-app.fs
            }
        }
    ]
    Behavior on w{NumberAnimation{duration: sweg.speedRotation}}
    Behavior on width {
        NumberAnimation{
            duration: 350
            easing.type: Easing.InOutQuad
        }
    }
    MouseArea {
        id: maw
        anchors.fill: parent
        onClicked: r.v=!r.v
        property int m:0
        property date uDate//: app.currentDate
        property int f: 0
        property int uY: 0
        onWheel: {
            let i=1
            if (wheel.modifiers & Qt.ControlModifier) {
                i=60
            }
            if (wheel.modifiers & Qt.ShiftModifier) {
                i=60*24
            }
            if(wheel.angleDelta.y===120){
                rotar(1,i)
            }else{
                rotar(0,i)
            }
            uY=wheel.angleDelta.y
        }
    }
    Item{
        id: xSignArcs
        anchors.fill: r
        rotation: r.rot
        Behavior on rotation {
            NumberAnimation{
                duration: sweg.speedRotation
                easing.type: Easing.InOutQuad
            }
        }
        Rectangle{
            anchors.fill: xSignArcs
            color: 'transparent'
            border.width: 2
            border.color: 'red'
            radius: width*0.5
            visible: r.showBorder
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                w: r.w
                n: index===0?1:(index===1?9:5)
                c:0
                gr: xSignArcs.rotation
                rotation: index*(360/3)-30
            }
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                w: r.w
                n: index===0?2:(index===1?10:6)
                c:1
                gr: xSignArcs.rotation
                rotation: index*(360/3)-60
            }
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                w: r.w
                n: index===0?3:(index===1?11:7)
                c:2
                gr: xSignArcs.rotation
                rotation: index*(360/3)-90
            }
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                w: r.w
                n: index===0?4:(index===1?12:8)
                c:3
                gr: xSignArcs.rotation
                rotation: index*(360/3)-120
            }
        }
    }
    Text {
        id: t1
        text: "F:"+r.f
        font.pixelSize: app.fs*3
        color: 'red'
        anchors.horizontalCenter: xSignArcs.horizontalCenter
        rotation: 90
        visible: false
    }
    property int sent: -1
    function subir(){
        rotar(1,1)
    }
    function bajar(){
        rotar(0,1)
    }
    property int uF: 0
    function rotar(s,i){
        let grado=0
        let currentDate=app.currentDate
        if(s===0){
            currentDate.setMinutes(currentDate.getMinutes() + i)
        }else{
            currentDate.setMinutes(currentDate.getMinutes() - i)
        }
        app.currentDate=currentDate
    }
}
