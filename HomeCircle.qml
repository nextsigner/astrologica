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
            console.log('GGGG:'+uY)
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
        id: xHomeArcs
        anchors.fill: r
        //rotation: 90
        visible: r.v
        Rectangle{
            anchors.fill: xHomeArcs
            color: 'transparent'
            border.width: 2
            border.color: 'red'
            radius: width*0.5
            visible: r.showBorder
        }
        Rectangle{
           id: ejeV
            width: r.width+app.fs*4
            height: 4
            color: 'red'
            anchors.centerIn: parent
            Rectangle{
                width: app.fs*0.5
                height: width
                radius: width*0.5
                color: parent.color
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        HomeArc{
            id: h1
            width: r.width
            height: width
            n: 1
            c: 0
            gr: 0
            wg:5
            rotation: 90
        }
        HomeArc{
            id: h2
            width: r.width
            height: width
            n: 1
            c: 1
            gr: 0
            wg:5
            rotation: 90
        }
    }
    Text{
        text: 'RHC:'+r.rotation
        font.pixelSize: 40
        color: 'blue'
        //x: 300
        visible: false
    }
    function load(jsonData) {
        /*let indexSign1=app.objSignsNames.indexOf(jsonData.pc.h1.s)
        console.log("is1:"+indexSign1)
        let p1=indexSign1*30+jsonData.pc.h1.g
        console.log("p1:"+p1)
        let indexSign2=app.objSignsNames.indexOf(jsonData.pc.h2.s)
        let p2=indexSign2*30+jsonData.pc.h2.g
        console.log("is2:"+indexSign2)
        console.log("p2:"+p2)
        h1.wg=p2-p1
        console.log("h1.wg:"+h1.wg)

        let gh1=p2-p1
        //h2.rotation=90+p2
        indexSign1=app.objSignsNames.indexOf(jsonData.pc.h2.s)
        p1=indexSign1*30+jsonData.pc.h2.g
        indexSign2=app.objSignsNames.indexOf(jsonData.pc.h3.s)
        p2=indexSign2*30+jsonData.pc.h3.g
        h2.rotation=h1.rotation+p2-p1
        h2.wg=p2-p1*/
    }
}
