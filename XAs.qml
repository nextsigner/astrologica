import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    id: r
    width: !selected?(planetsCircle.expand?parent.width-(r.fs*2*objData.p):parent.width-(r.fs*0.5*objData.p)):parent.width-app.fs*2
    height: 1
    anchors.centerIn: parent
    property bool selected: numAstro === panelDataBodies.currentIndex
    property string astro
    property int is
    property int fs
    property var objData: ({g:0, m:0,ih:0,rsgdeg:0,rsg:0})
    property int pos: 1
    property int g: -1
    property int m: -1
    property int numAstro: 0
    onWidthChanged: {
//        if(r.width===r.parent.width-app.fs*2){
//            r.opacity=1.0
//        }else{
//            r.opacity=0.5
//        }
    }
    onSelectedChanged: {
        if(selected)housesCircle.currentHouse=objData.ih
    }
    Rectangle{
        anchors.fill: parent
        color: 'transparent'
        Rectangle{
            width: parent.width*0.5
            height: 4
            color: 'transparent'
            visible: r.selected
            anchors.verticalCenter: parent.verticalCenter
            Rectangle{
                width: r.selected?parent.width:0
                height: 4
                color: app.signColors[r.is]
                Behavior on width {
                    NumberAnimation{
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
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
        Rectangle{
            //Circulo que queda mostrando el cuerpo chico.
            width: parent.width+app.fs*0.35
            height: width
            anchors.centerIn: parent
            radius: width*0.5
            border.width: 2
            border.color: 'white'
            opacity: r.selected?1.0:0.0
            color: app.signColors[r.is]
        }
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
        Rectangle{
            id: fondoImgCentral
            opacity: r.selected?1.0:0.0
            width: img.width*1.5
            height: width
            color: app.signColors[r.is]//'white'
            radius: width*0.5
            border.width: 2
            border.color: 'white'
            anchors.centerIn: img
            TripleCircle{
                id: tripeCircle
                rotation: 0-parent.parent.rotation
                is:r.is
                gdeg: objData.g
                mdeg: objData.m
                rsgdeg:objData.rsg
                ih:objData.ih
                expand: r.selected
            }
        }
        Image {
            id: img0
            source: img.source
            width: parent.width
            height: width
            rotation: 0-parent.parent.rotation
        }
        Image {
            id: img
            source: "./resources/imgs/planetas/"+app.planetasRes[r.numAstro]+".svg"
            width: !r.selected?parent.width:parent.width*2
            height: width
            x:!r.selected?0:r.parent.width*0.5-img.width*0.5-app.fs//-(r.fs*2*objData.p)
            y: (parent.width-width)/2
            rotation: 0-parent.parent.rotation
            Behavior on width {
                NumberAnimation{
                    duration: 350
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on x {
                NumberAnimation{
                    duration: 350
                    easing.type: Easing.InOutQuad
                }
            }
        }
        ColorOverlay {
            id: co
            anchors.fill: img
            source: img
            color: "#ffffff"//r.selected?"#000000":"#ffffff"
            rotation: img.rotation
            SequentialAnimation{
                running: r.selected
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
}
