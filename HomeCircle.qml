import QtQuick 2.0

Item {
    id: r
    property int currentHouse: -1
    property int w: sweg.fs*3
    property int wb: 1//sweg.fs*0.15
    property int f: 0
    property bool v: false
    property bool showBorder: false
    property var arrayWg: []
    property string extraObjectName: ''
    property var swegParent//: value
    property int widthAspCircle: 10
    state: r.parent.state
    states: [
        State {
            name: r.parent.aStates[0]
            PropertyChanges {
                target: r
                //width: housesCircle.parent.objectName==='sweg'?(r.parent.width-sweg.fs-sweg.fs):(r.parent.width-sweg.fs)
                width: r.parent.width-sweg.fs-sweg.fs
            }
        },
        State {
            name: r.parent.aStates[1]
            PropertyChanges {
                target: r
                //width: housesCircle.parent.objectName==='sweg'?(r.parent.width-sweg.fs*5-sweg.fs):(r.parent.width-sweg.fs*2.5-sweg.fs*0.5)
                width: r.parent.width-sweg.fs*5-sweg.fs
            }
        },
        State {
            name: r.parent.aStates[2]
            PropertyChanges {
                target: r
                //width: housesCircle.parent.objectName==='sweg'?(r.parent.width-sweg.fs-sweg.fs):(r.parent.width)
                width: r.parent.width-sweg.fs-sweg.fs
            }
        }
    ]
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
                    objectName: 'HomeArc'+index+'_'+r.extraObjectName
                    //width: r.width
                    height: width
                    //w:r.w
                    //z:index===0?12:11+index
                    n: index+1
                    c: index
                    gr: 0
                    wg:5
                    wb: r.wb
                    rotation: 90
                    onSelectedChanged: {
                        /*var objH1
                        var objH2
                        var objH12
                        for(var i=0;i<xArcs.children.length;i++){
                            console.log('--->>'+xArcs.children[i].objectName)
                            if(i===0)objH1=xArcs.children[i]
                            if(i===0)objH2=xArcs.children[i]
                            if(i===0)objH12=xArcs.children[i]
                        }
                        if(n===0){
                                objH1.z=20
                                objH2.z=21
                                //objH12.z=12
                        }else{
                            objH1.z=objH12.z-11
                            objH2.z=objH1.z+1
                        }*/
                    }
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
        //let comp=Qt.createComponent("HomeArc.qml")
        //let obj=comp.createObject(xArcs, {width: r.width, height:r.width, w: r.w, n:0+1, c: 0, gr:0, wg:5, rotation:90})
        //setHousesArcs()
    }
    function loadHouses(jsonData) {
        r.arrayWg=[]
        if(true){
            loadHouses2(jsonData)
            return
        }
        //setHousesArcs()
        let sumaInf=0.0
        let f1
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
            if(i===0){
                app.uAscDegreeTotal=jsonData.ph.h1.gdec
            }
            nh=i
            let h=xArcs.children[i]
            h.op=0.0
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
            resta+=xArcs.children[nh].wg-(o1.mdeg/60)-(o2.mdeg/60)
            r.arrayWg.push(h.wg)
            //console.log('r.arrayWg: '+r.arrayWg.toString())
        }
    }
    function loadHouses2(jsonData) {
        /*r.z=sweg.objPlanetsCircle.z+1
        sweg.objSignsCircle.visible=false
        r.wb=1
        sweg.state='pc'
        */
        r.arrayWg=[]
        xArcs.rotation=90

        let sumaInf=0.0
        let f1
        let resta=0.000000
        let nh=0
        let o1//=jsonData.pc.h1
        let o2//=jsonData.pc.h2
        let indexSign1//=app.objSignsNames.indexOf(o1.s)
        let p1//=indexSign1*30+o1.g
        let indexSign2//=app.objSignsNames.indexOf(o2.s)
        let p2//=indexSign2*30+o2.g
        let gp=[]
        for(var i=0;i<12;i++){
            if(i===0){
                app.uAscDegreeTotal=jsonData.ph.h1.gdec
            }
            nh=i
            let h=xArcs.children[i]
            /*if(i>12){
                h.visible=false
            }else{
                h.showEjeCentro=true
            }*/
            h.op=0.0
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
            //p1=parseInt(indexSign1*30)
            indexSign2=o2.is//app.objSignsNames.indexOf(o2.s)
            p2=0.0000+indexSign2*30+o2.rsgdeg+(o2.mdeg/60)
            //p2=parseInt(indexSign2*30)
            let wgf=parseInt(p2)-parseInt(p1)//+(o1.mdeg/60)
            if(wgf<0){
                h.wg=360+p2-p1//+(o1.mdeg/60)
            }else{
                h.wg=p2-p1//+(o1.mdeg/60)
            }
            if(i===0){
                h.rotation=0
            }else{
                if(i===1){
                    h.rotation=360-gp[i-1]
                }
                if(i===2){
                    h.rotation=360-(gp[i-1]+gp[i-2])
                }
                if(i===3){
                    h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3])
                }
                if(i===4){
                    h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4])
                }
                if(i===5){
                    h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5])
                }
                if(i===6){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6])
                }
                if(i===7){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7])
                }
                if(i===8){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8])
                }
                if(i===9){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8]+gp[i-9])
                }
                if(i===10){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8]+gp[i-9]+gp[i-10])
                }
                if(i===11){
                    h.rotation=h.rotation=360-(gp[i-1]+gp[i-2]+gp[i-3]+gp[i-4]+gp[i-5]+gp[i-6]+gp[i-7]+gp[i-8]+gp[i-9]+gp[i-10]+gp[i-11])
                }
            }
            //h.rotation=360-resta-(o1.mdeg/60)
            gp.push(wgf)
            /*if(i<5){
                f1=h.wg
                if(f1<0){
                    f1=360+f1
                }
                console.log('f1: '+f1)
                sumaInf+=f1
                console.log('sumaInf: '+sumaInf)
            }
            if(i===6){
                let wg6=180-sumaInf
                console.log('wg6: '+wg6)
                h.wg=wg6
                h.rotation=90-180
            }
            if(i===11){
                let wg11=sumaInf
                console.log('wg11: '+wg11)
                h.wg=wg11
                h.rotation=90//-360
            }*/
            //console.log('wg: '+h.wg)
            //console.log('Rotación: '+h.rotation)
            //console.log('Desde: '+p1+' hasta:'+p2)
            //console.log('wg: '+h.wg+' rot: '+h.rotation)
            resta+=xArcs.children[nh].wg-(o1.mdeg/60)-(o2.mdeg/60)
            r.arrayWg.push(h.wg)
        }
    }
}
