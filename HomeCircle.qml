import QtQuick 2.0

Item {
    id: r
    property int w: 20
    property int f: 0
    property bool v: false
    property bool showBorder: false
    Behavior on rotation{
        NumberAnimation{duration:2000;easing.type: Easing.InOutElastic}
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
    Component.onCompleted: {
        let comp=Qt.createComponent("HomeArc.qml")
        let obj=comp.createObject(xArcs, {width: r.width, height:r.width, w: r.w, n:0+1, c: 0, gr:0, wg:5, rotation:90})
    //setHousesArcs()
    }
    function loadHouses(jsonData) {
        //setHousesArcs()
        let resta=0.000000
        let nh=0
        let o1//=jsonData.pc.h1
        let o2//=jsonData.pc.h2
        let indexSign1//=app.objSignsNames.indexOf(o1.s)
        let p1//=indexSign1*30+o1.g
        let indexSign2//=app.objSignsNames.indexOf(o2.s)
        let p2//=indexSign2*30+o2.g
        //xArcs.children[nh].wg=p2-p1
        //resta+=xArcs.children[nh].wg
         //return
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
                o1=jsonData.ph[sh1]
                o2=jsonData.ph[sh2]
            }else{
                sh1='h'+parseInt(nh + 1)
                sh2='h'+parseInt(nh + 2)
                //console.log('Ob2: '+sh1+ ' '+sh2)
                o1=jsonData.ph[sh1]
                o2=jsonData.ph[sh2]
            }
            //indexSign1=app.objSignsNames.indexOf(o1.s)
            indexSign1=o1.is
            p1=indexSign1*30+o1.rsgdeg
            indexSign2=o2.is//app.objSignsNames.indexOf(o2.s)
            p2=0.0000+indexSign2*30+o2.rsgdeg+(o2.mdeg/60)
            h.wg=p2-p1+(o1.mdeg/60)
            h.rotation=90-resta-(o1.mdeg/60)
            //console.log('wg: '+h.wg+' rot: '+h.rotation)
            resta+=xArcs.children[nh].wg-(o1.mdeg/60)-(o2.mdeg/60)
        }
    }
    function load(jsonData) {
        //setHousesArcs()
        let resta=0.000000
        let nh=0
        let o1//=jsonData.pc.h1
        let o2//=jsonData.pc.h2
        let indexSign1//=app.objSignsNames.indexOf(o1.s)
        let p1//=indexSign1*30+o1.g
        let indexSign2//=app.objSignsNames.indexOf(o2.s)
        let p2//=indexSign2*30+o2.g
        //xArcs.children[nh].wg=p2-p1
        //resta+=xArcs.children[nh].wg
         //return
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
            p2=0.0000+indexSign2*30+o2.g+(o2.m/60)
            h.wg=p2-p1+(o1.m/60)
            h.rotation=90-resta-(o1.m/60)
            console.log('wg: '+h.wg+' rot: '+h.rotation)
            resta+=xArcs.children[nh].wg-(o1.m/60)-(o2.m/60)
        }
    }
}
