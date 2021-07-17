import QtQuick 2.0

Item {
    id: r
    width: app.fs*10
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
            enabled: app.enableAn;
            NumberAnimation{
                duration: sweg.speedRotation
                easing.type: Easing.InOutQuad
            }
        }
        Repeater{
            model:r.parent.parent.objectName!=='sweg'? [0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11]:[]
            SignArcDec2{
                //opacity: index===0?0.2:1.0
                width: r.width
                height: width
                w: r.w*0.5
                n: modelData
                c: app.signColors[modelData]
                gr: r.rotation
                rotation: 360-index*3.333333-3.333333
            }
        }
        Component.onCompleted: {
            for(var i=0;i<12;i++){
                let comp=Qt.createComponent("SignArcDec.qml")
                let obj=comp.createObject(xSignArcs, {width: r.width,height: width, w: r.w, n:i, c:app.signColors[i], gr: xSignArcs.rotation, rotation: i*10})
            }
        }
    }
}
