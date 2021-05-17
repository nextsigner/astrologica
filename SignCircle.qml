import QtQuick 2.0

Item {
    id: r
    property int f: 0
    property bool v: false
    property bool showBorder: false
    MouseArea {
        id: maw
        anchors.fill: parent
        onClicked: r.v=!r.v
        property int m:0
        property date uDate//: app.currentDate
        property int f: 0
        property int uY: 0
        onWheel: {
            //if (wheel.modifiers & Qt.ControlModifier) {
            //let g=wheel.angleDelta.y / 120
            //console.log('GGGG:'+uY)
            if(wheel.angleDelta.y===120){
                rotar(0)
            }else{
                rotar(1)
            }
            uY=wheel.angleDelta.y
            //}
        }
    }
    Item{
        id: xSignArcs
        anchors.fill: r
        //rotation: 90
        //visible: r.v
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
                n: index===0?1:(index===1?9:5)
                c:0
                gr: r.rotation
                rotation: index*(360/3)-30
            }
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                
                n: index===0?2:(index===1?10:6)
                c:1
                gr: r.rotation
                rotation: index*(360/3)-60
            }
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                n: index===0?3:(index===1?11:7)
                c:2
                gr: r.rotation
                rotation: index*(360/3)-90
            }
        }
        Repeater{
            model: 3
            SignArc{
                width: r.width
                height: width
                n: index===0?4:(index===1?12:8)
                c:3
                gr: r.rotation
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
        rotar(1)
    }
    function bajar(){
        rotar(0)
    }
    property int uF: 0
    function rotar(s){
        let grado=0
        let currentDate=app.currentDate
        if(s===0){
            currentDate.setMinutes(currentDate.getMinutes() + 1)
            grado=-1
            if(r.f>2){
                r.f=0
            }else{
                r.f++
            }
            uF--
        }else{
            currentDate.setMinutes(currentDate.getMinutes() - 1)
            grado=1
            if(r.f<1){
                r.f=3
            }else{
                r.f--
            }
            uF++
        }
        if(r.f===0&grado===-1){
            if(s===0){
                r.rotation=r.rotation+1
            }
        }
        if(r.f===3&grado===1){
            if(s===1){
                r.rotation=r.rotation-1
            }
        }
        //let newDate=currentDate
        app.currentDate=currentDate//newDate
        //r.uF=r.f
    }
}
