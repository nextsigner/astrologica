import QtQuick 2.0

Item {
    id: r
    property int w: 20
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
        Item{
            id:xArcs
            anchors.fill: parent
            Repeater{
                model: 12
                HomeArc{
                    objectName: 'HomeArc'+index
                    width: r.width
                    height: width
                    w:r.w
                    n: index+1
                    c: index
                    gr: 0
                    wg:5
                    rotation: 90
                }
            }
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
        let resta=0
        let nh=0
        let o1//=jsonData.pc.h1
        let o2//=jsonData.pc.h2
        let indexSign1//=app.objSignsNames.indexOf(o1.s)
        let p1//=indexSign1*30+o1.g
        let indexSign2//=app.objSignsNames.indexOf(o2.s)
        let p2//=indexSign2*30+o2.g
        //xArcs.children[nh].wg=p2-p1
        //resta+=xArcs.children[nh].wg

        for(var i=0;i<12;i++){
            nh=i
            let h=xArcs.children[i]
            //console.log('HomeArc: '+h.objectName)
            let sh1=''
            let sh2=''
            if(i===11){
                sh1='h'+parseInt(nh + 1)
                sh2='h1'
                //console.log('Ob1: '+sh1+ ' '+sh2)
                o1=jsonData.pc[sh1]
                o2=jsonData.pc[sh2]
            }else{
                sh1='h'+parseInt(nh + 1)
                sh2='h'+parseInt(nh + 2)
                //console.log('Ob2: '+sh1+ ' '+sh2)
                o1=jsonData.pc[sh1]
                o2=jsonData.pc[sh2]
            }
            indexSign1=app.objSignsNames.indexOf(o1.s)
            p1=indexSign1*30+o1.g
            indexSign2=app.objSignsNames.indexOf(o2.s)
            p2=indexSign2*30+o2.g
            h.rotation=90-resta

            h.wg=p2-p1
            resta+=xArcs.children[nh].wg
        }

        /*nh=1
        let h=xArcs.children[nh]
        o1=jsonData.pc['h'+parseInt(nh + 1)]
        o2=jsonData.pc['h'+parseInt(nh + 2)]
        indexSign1=app.objSignsNames.indexOf(o1.s)
        p1=indexSign1*30+o1.g
        indexSign2=app.objSignsNames.indexOf(o2.s)
        p2=indexSign2*30+o2.g
        //h.rotation=90-xArcs.children[nh-1].wg
        h.rotation=90-resta
        h.wg=p2-p1
        resta+=xArcs.children[nh].wg

        nh=2
        h=xArcs.children[nh]
        o1=jsonData.pc.h3
        o2=jsonData.pc.h4
        indexSign1=app.objSignsNames.indexOf(o1.s)
        p1=indexSign1*30+o1.g
        indexSign2=app.objSignsNames.indexOf(o2.s)
        p2=indexSign2*30+o2.g
        //h.rotation=90-xArcs.children[nh-1].wg-xArcs.children[nh-2].wg
        h.rotation=90-resta
        h.wg=p2-p1
        resta+=xArcs.children[nh].wg

        nh=3
        h=xArcs.children[nh]
        o1=jsonData.pc.h4
        o2=jsonData.pc.h5
        indexSign1=app.objSignsNames.indexOf(o1.s)
        p1=indexSign1*30+o1.g
        indexSign2=app.objSignsNames.indexOf(o2.s)
        p2=indexSign2*30+o2.g
        //h.rotation=90-xArcs.children[nh-1].wg-xArcs.children[nh-2].wg-xArcs.children[nh-3].wg
        h.rotation=90-resta
        h.wg=p2-p1
        resta+=xArcs.children[nh].wg

        nh=4
        h=xArcs.children[nh]
        o1=jsonData.pc.h5
        o2=jsonData.pc.h6
        indexSign1=app.objSignsNames.indexOf(o1.s)
        p1=indexSign1*30+o1.g
        indexSign2=app.objSignsNames.indexOf(o2.s)
        p2=indexSign2*30+o2.g
        //h.rotation=90-xArcs.children[nh-1].wg-xArcs.children[nh-2].wg-xArcs.children[nh-3].wg-xArcs.children[nh-4].wg
        h.rotation=90-resta
        h.wg=p2-p1
        resta+=xArcs.children[nh].wg

        h=xArcs.children[4]
        o1=jsonData.pc.h5
        o2=jsonData.pc.h6
        indexSign1=app.objSignsNames.indexOf(o1.s)
        p1=indexSign1*30+o1.g
        indexSign2=app.objSignsNames.indexOf(o2.s)
        p2=indexSign2*30+o2.g
        h.rotation=90-xArcs.children[0].wg-xArcs.children[1].wg-xArcs.children[2].wg-xArcs.children[3].wg
        h.wg=p2-p1*/


    }
}
