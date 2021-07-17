import QtQuick 2.0

Item {
    id: r
    width: app.fs*10
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
                //width: sweg.width-sweg.fs*2
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                //width: sweg.width-sweg.fs*6-sweg.fs
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                //width: sweg.width-sweg.fs*2-sweg.fs
            }
        }
    ]
    //Behavior on w{NumberAnimation{duration: sweg.speedRotation}}
//    Behavior on width {
//        NumberAnimation{
//            duration: 350
//            easing.type: Easing.InOutQuad
//        }
//    }
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
        Repeater{
            model:r.parent.parent.objectName!=='sweg'? [0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11]:[]
            SignArcDec2{
                width: r.width
                height: width
                w: r.w*0.5
                n: modelData
                c: app.signColors[modelData]
                gr: xSignArcs.rotation
                rotation: 360-index*3.333333-3.333333
                //z:36-index
                //colors: [0,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1]
            }
        }
        /*Repeater{
            model: 3
            SignArcDec{
                width: r.width
                height: width
                w: r.w
                n: index===0?2:(index===1?10:6)
                c:1
                gr: xSignArcs.rotation
                rotation: index*(360/3)-60
                //colors: [1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
            }
        }
        Repeater{
            model: 3
            SignArcDec{
                width: r.width
                height: width
                w: r.w
                n: index===0?3:(index===1?11:7)
                c:2
                gr: xSignArcs.rotation
                rotation: index*(360/3)-90
                //colors: [1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
            }
        }
        Repeater{
            model: 3
            SignArcDec{
                width: r.width
                height: width
                w: r.w
                n: index===0?4:(index===1?12:8)
                c:3
                gr: xSignArcs.rotation
                rotation: index*(360/3)-120
                //colors: [1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
            }
        }
        */
        Component.onCompleted: {

            for(var i=0;i<12;i++){
                let comp=Qt.createComponent("SignArcDec.qml")
                let obj=comp.createObject(xSignArcs, {width: r.width,height: width, w: r.w, n:i, c:app.signColors[i], gr: xSignArcs.rotation, rotation: i*10})
                /*SignArcDec{
                width: r.width
                height: width
                w: r.w
                n: index===0?1:(index===1?9:5)
                c:0
                gr: xSignArcs.rotation
                rotation: index*(360/3)-30
                //colors: [0,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1]
            }*/
            }
        }
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
