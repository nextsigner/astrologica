import QtQuick 2.0

Item {
    id: r
    width: signCircle.width-signCircle.w*0.5+1
    height: width
    anchors.centerIn: parent
    property int f: 0
    property int w: sweg.fs
    property bool v: false
    property bool showBorder: false
    property int rot: 0
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
            model: r.parent.objectName!=='sweg'?[0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11]:[]
            SignArcDec{
                width: r.width
                height: width
                w: r.w*0.5
                n: modelData
                c: app.signColors[modelData]
                gr: xSignArcs.rotation
                rotation: 360-index*10-10
                //z:36-index
                //colors: [0,1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1]
            }
        }       
        Component.onCompleted: {
            for(var i=0;i<12;i++){
                let comp=Qt.createComponent("SignArcDec.qml")
                let obj=comp.createObject(xSignArcs, {width: r.width,height: width, w: r.w, n:i, c:app.signColors[i], rotation: i*10})
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
    SignCircleDec2{
        id:signCircleDec2
        width: r.width-r.w+1//signCircleDec.width*0.5//-(signCircle.w*0.5)*2+1
        height: width
        anchors.centerIn: parent
        showBorder: false
        v:r.v
        rotation: xSignArcs.rotation
    }
}
