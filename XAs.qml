import QtQuick 2.0
import QtGraphicalEffects 1.0

Item{
    id: r
    width: !selected?(planetsCircle.expand?parent.width-(r.fs*2*objData.p)-r.fs:parent.width-(r.fs*1.5*objData.p))-r.fs:parent.width//-app.fs*2-(r.fs*1.5*(planetsCircle.totalPosX-1))
    height: 1
    anchors.centerIn: parent
    z: !selected?numAstro:15
    property bool selected: numAstro === panelDataBodies.currentIndex
    property string astro
    property int is
    property int fs
    property var objData: ({g:0, m:0,ih:0,rsgdeg:0,rsg:0})
    property int pos: 1
    property int g: -1
    property int m: -1
    property int numAstro: 0

    property color colorCuerpo: '#ff3300'

    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                colorCuerpo: '#ffffff'
            }
            PropertyChanges {
                target: xIcon
                width: r.fs*0.85
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                colorCuerpo: '#000000'
            }
            PropertyChanges {
                target: xIcon
                width: r.fs*0.5
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                colorCuerpo: '#ffffff'
            }
            PropertyChanges {
                target: xIcon
                width: r.fcs*0.5
            }
        }
    ]

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
                id: lineaATripleCircle
                width: r.selected?parent.width:0
                height: 4
                SequentialAnimation on color {
                    running: true
                    loops: Animation.Infinite
                    PropertyAnimation {
                        target: lineaATripleCircle; property: "color"
                        from: 'red'
                        to: 'yellow'
                    }
                    PauseAnimation {
                        duration: 100
                    }
                    PropertyAnimation {
                        target: lineaATripleCircle; property: "color"
                        from: 'yellow'
                        to: 'red'
                    }
                }
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
        id: xIcon
        //width: r.fs*0.85
        height: width
        anchors.left: parent.left
        //anchors.leftMargin: !r.selected?0:width*0.5
        anchors.verticalCenter: parent.verticalCenter
        Rectangle{
            //Circulo que queda mostrando el cuerpo chico.
            width: parent.width+app.fs*0.35
            height: width
            anchors.centerIn: parent
            radius: width*0.5
            border.width: 2
            border.color: lineaATripleCircle.color
            opacity: r.selected?1.0:0.0
            color: 'black'//app.signColors[r.is]
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
            color: 'black'//app.signColors[r.is]//'white'
            radius: width*0.5
            border.width: 2
            border.color: lineaATripleCircle.color
            anchors.centerIn: img
            TripleCircle{
                id: tripeCircle
                //rotation: 0-parent.parent.rotation
                is:r.is
                gdeg: objData.g
                mdeg: objData.m
                rsgdeg:objData.rsg
                ih:objData.ih
                expand: r.selected
                iconoSignRot: img.rotation
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
            x:!r.selected?0:r.parent.width*0.5-img.width*0.5//+app.fs*2
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
            color: lineaATripleCircle.color
            rotation: img.rotation
            visible: r.selected
        }
        ColorOverlay {//Planeta que se muestra en espera no seleccionado
            id: co0
            anchors.fill: img0
            source: img0
            //color: lineaATripleCircle.color//r.colorCuerpo
            rotation: img.rotation
            visible: !r.selected
            SequentialAnimation{
                running: true//r.selected
                loops: Animation.Infinite
                PropertyAnimation {
                    target: co0
                    properties: "color"
                    from: 'red'
                    to: 'white'
                    duration: 500
                }
                PropertyAnimation {
                    target: co0
                    properties: "color"
                    from: 'red'
                    to: 'red'
                    duration: 500
                }
            }
        }
        ColorOverlay {
            id: co1
            anchors.fill: img0
            source: img0
            color: lineaATripleCircle.color//r.colorCuerpo
            rotation: img.rotation
            visible: r.selected
        }
    }
}
