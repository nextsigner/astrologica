import QtQuick 2.0

Item {
    id: r
    property int f: 0
    property int w: sweg.fs
    property bool v: false
    property bool showBorder: false
    property int rot: 0
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*2
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*6
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*2
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
    Repeater{
        model: 36
        Item{
            width: r.width
            height: 1
            anchors.centerIn: parent
            rotation: 10*index
            MouseArea {
                id: maw
                width: r.w*0.9
                height: r.w*1.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin:  0-sweg.fs*0.05
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
                        rotar(0,i)
                    }else{
                        rotar(1,i)
                    }
                    uY=wheel.angleDelta.y
                }
            }
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
        font.pixelSize: sweg.fs*3
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
    function rotarSegundos(s){
        let currentDate=app.currentDate
        if(s===0){
            currentDate.setSeconds(currentDate.getSeconds() + 10)
        }else{
            currentDate.setSeconds(currentDate.getSeconds() - 10)
        }
        app.currentDate=currentDate
    }
}
