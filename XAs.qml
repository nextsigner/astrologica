import QtQuick 2.0
import QtGraphicalEffects 1.0
Item{
    id: r
    width: planetsCircle.expand?parent.width-(r.fs*2*objData.p):parent.width-(r.fs*0.5*objData.p)
    height: 1
    anchors.centerIn: parent
    property string astro
    property string numSign
    property int fs
    property var objData: ({})
    property int pos: 1
    property int g: -1
    property int m: -1
    property int numAstro: -1

    Behavior on width {
        NumberAnimation{
            duration: 350
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on rotation {
        NumberAnimation{
            duration: sweg.speedRotation
            easing.type: Easing.InOutQuad
        }
    }

    Item{
        width: r.fs*0.85
        height: width
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        MouseArea{
            id: maSig
            property int vClick: 0
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                vClick=0
                r.parent.cAs=r
            }
            onExited: {
                vClick=0
                //r.parent.cAs=r.parent
            }
            onClicked: {
                vClick++
                tClick.restart()
                //r.parent.pressed(r)
            }
            onDoubleClicked: {
                tClick.stop()
                r.parent.doublePressed(r)
            }
            Timer{
                id: tClick
                running: false
                repeat: false
                interval: 500
                onTriggered: {
                    if(maSig.vClick<=1){
                        r.parent.pressed(r)
                    }else{
                        r.parent.doublePressed(r)
                    }
                }
            }
        }
        Image {
            id: img
            source: "./resources/imgs/planetas/"+app.planetasRes[r.numAstro]+".svg"
            width: parent.width
            height: width
            anchors.centerIn: parent
            rotation: 0-parent.parent.rotation
        }
        ColorOverlay {
            id: co
                anchors.fill: img
                source: img
                color: "#ffffff"
                rotation: img.rotation
                SequentialAnimation{
                    running: true
                    loops: Animation.Infinite
                    PropertyAnimation {
                        target: co
                        properties: "opacity"
                        from: 0.0
                        to: 1.0
                    }

                    PauseAnimation {
                        duration: 500
                    }
                    PropertyAnimation {
                        target: co
                        properties: "opacity"
                        from: 1.0
                        to: 0.0
                    }
                }
            }
    }
    //    Text{
    //        font.pixelSize: 20
    //        text:  r.objData.h
    //        color: 'red'
    //    }
}
