import QtQuick 2.0

Item {
    id: r
    property bool v: false
    property bool showBorder: false
    MouseArea {
        id: maw
        anchors.fill: parent
        onClicked: r.v=!r.v
        property int m:0
        property date uDate//: app.currentDate
        property int f: 0
        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {

                if(!uDate)uDate=app.currentDate
                let g=wheel.angleDelta.y / 120
                r.rotation=r.rotation-g
                let currentDate=app.currentDate
                let grado=0
                if(g>0){
                    currentDate.setMinutes(currentDate.getMinutes() - 1)
                    grado=-1
                    if(f>4){
                        f=0
                    }else{
                        f++
                    }
                }else{
                    currentDate.setMinutes(currentDate.getMinutes() + 1)
                    grado=1
                }
                let cuatroMinEnMs=60*4*1000
                if(uDate.getTime()-cuatroMinEnMs>=currentDate.getTime() && uDate.getTime()+cuatroMinEnMs<=currentDate.getTime()){
                    r.rotation=r.rotation-grado
                    uDate=currentDate
                }
                let newDate=currentDate
                app.currentDate=newDate
            }
        }
    }
    Item{
        id: xSignArcs
        anchors.fill: r
        visible: r.v
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
                rotation: index*(360/3)
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
                rotation: index*(360/3)-30
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
                rotation: index*(360/3)-60
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
                rotation: index*(360/3)-90
            }
        }
    }
}
