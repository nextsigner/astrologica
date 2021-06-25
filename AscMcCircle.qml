import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    id: r
    anchors.centerIn: parent
    property int isAsc: 0
    property int isMC: 0
    property int gdegAsc: -1
    property int mdegAsc: -1
    property int gdegMC: -1
    property int mdegMC: -1

    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                width: sweg.width
            }
            PropertyChanges {
                target: ejeAsc
                width: sweg.objSignsCircle.width+sweg.fs*0.5
            }
            PropertyChanges {
                target: ejeMC
                width: sweg.objSignsCircle.width+sweg.fs*0.5
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*5
            }
            PropertyChanges {
                target: ejeAsc
                width: sweg.objSignsCircle.width+sweg.fs*3
            }
            PropertyChanges {
                target: ejeMC
                width: sweg.objSignsCircle.width+sweg.fs*3
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs
            }
            PropertyChanges {
                target: ejeAsc
                width: sweg.objSignsCircle.width
            }
            PropertyChanges {
                target: ejeMC
                width: sweg.objSignsCircle.width
            }
        }
    ]
    Rectangle{
        id: ejeCard1
        width: ejeAsc.width+sweg.fs*2
        height: 1//sweg.fs*0.1
        color: 'red'
        anchors.centerIn: r
        anchors.horizontalCenterOffset: 0-sweg.fs
        //opacity: app.currentPlanetIndex===15?1.0:0.0
        state: app.currentPlanetIndex===15?'showAsc':'hideAsc'
        states: [
            State {
                name: 'showAsc'
                PropertyChanges {
                    target: ejeCard1
                    width: ejeAsc.width+sweg.fs*4
                }
            },
            State {
                name: 'hideAsc'
                PropertyChanges {
                    target: ejeCard1
                    width: ejeAsc.width+sweg.fs*2
                }
            }
        ]
        Behavior on opacity{NumberAnimation{duration: 500}}
        Canvas {
            id:canvas
            width: sweg.fs*0.5
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            antialiasing: true
            onPaint:{
                var ctx = canvas.getContext('2d');
                ctx.beginPath();
                ctx.moveTo(0, canvas.width*0.5);
                ctx.lineTo(canvas.width, 0);
                ctx.lineTo(canvas.width, canvas.width);
                ctx.lineTo(0, canvas.width*0.5);                               ctx.strokeStyle = canvas.parent.color
                ctx.lineWidth = canvas.parent.height;
                ctx.fillStyle = canvas.parent.color
                ctx.fill();
                ctx.stroke();

            }
        }
    }
    Rectangle{
        id: ejeAsc
        width: sweg.objSignsCircle.width
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        antialiasing: true
        Rectangle{
            id: xIconAsc
            property bool selected: app.currentPlanetIndex===15
            width: selected?sweg.fs*2:sweg.fs
            height: width
            radius: width*0.5
            color: 'black'
            border.width: sweg.objHousesCircle.wb
            border.color: co.color
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            onSelectedChanged:{
                app.uSon='asc_'+app.objSignsNames[r.isAsc]+'_1'
            }
            state: sweg.state
            states: [
                State {
                    name: sweg.aStates[0]
                    PropertyChanges {
                        target: xIconAsc
                        anchors.rightMargin: 0
                    }
                },
                State {
                    name: sweg.aStates[1]
                    PropertyChanges {
                        target: xIconAsc
                        anchors.rightMargin: app.currentPlanetIndex===15?0- housesCircle.width*0.5-xIconAsc.width*0.5-sweg.fs*1.5:0
                    }
                },
                State {
                    name: sweg.aStates[2]
                    PropertyChanges {
                        target: xIconAsc
                        anchors.rightMargin: 0
                    }
                }
            ]
            SequentialAnimation on color {
                running: true
                loops: Animation.Infinite
                PropertyAnimation {
                    target: co;
                    property: "color"
                    from: 'red'
                    to: 'yellow'
                }
                PauseAnimation {
                    duration: 100
                }
                PropertyAnimation {
                    target: co;
                    property: "color"
                    from: 'yellow'
                    to: 'red'
                }
            }
            Behavior on anchors.rightMargin{NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
            Behavior on width{NumberAnimation{duration: 250;easing.type: Easing.InOutQuad}}
            Image {
                id: img
                source: "./resources/imgs/signos/"+r.isAsc+".svg"
                width: parent.width*0.65
                height: width
                anchors.centerIn: parent
            }
            ColorOverlay {
                id: co
                anchors.fill: img
                source: img
                color: 'red'
            }
            Column{
                //anchors.centerIn: co
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                spacing: sweg.fs*0.05
                Text{
                    text: 'Asc '+app.signos[r.isAsc]
                    font.pixelSize: sweg.fs*0.5
                    color: 'white'
                    width: contentWidth
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignRight
                    Rectangle{
                        width: parent.contentWidth+3
                        height: parent.contentHeight+3
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: sweg.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        antialiasing: true
                        anchors.centerIn: parent
                    }
                }
                Item{width: xIconAsc.width;height: width}
                Text{
                    text: '°'+r.gdegAsc+' \''+r.mdegAsc+''
                    font.pixelSize: sweg.fs*0.5
                    color: 'white'
                    width: contentWidth
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignRight
                    Rectangle{
                        width: parent.contentWidth+3
                        height: parent.contentHeight+3
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: sweg.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        anchors.centerIn: parent
                        antialiasing: true
                    }
                }
            }
        }
    }
    Rectangle{
        id: ejeMC
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        antialiasing: true
        Rectangle{
            id: xIconMC
            property bool selected: app.currentPlanetIndex===16
            width: selected?sweg.fs*2:sweg.fs
            height: width
            radius: width*0.5
            color: 'black'
            border.width: sweg.objHousesCircle.wb
            border.color: co2.color
            antialiasing: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: 0
            //opacity: app.currentPlanetIndex===16&&anchors.rightMargin!==0?1.0:0.0
            Behavior on anchors.rightMargin{NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
            Behavior on x{NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
            state: sweg.state
            states: [
                State {
                    name: sweg.aStates[0]
                    PropertyChanges {
                        target: xIconMC
                        anchors.rightMargin: 0
                    }
                    PropertyChanges {
                        target: xIconMC
                        //opacity:1.0
                    }
                },
                State {
                    name: sweg.aStates[1]
                    PropertyChanges {
                        target: xIconMC
                        anchors.rightMargin: app.currentPlanetIndex===16?0- housesCircle.width*0.5-xIconMC.width*0.5-sweg.fs*1.5:0
                    }
                    PropertyChanges {
                        target: xIconMC
                        //opacity:app.currentPlanetIndex===16?1.0:0.0
                    }
                },
                State {
                    name: sweg.aStates[2]
                    PropertyChanges {
                        target: xIconMC
                        anchors.rightMargin: 0
                    }
                    PropertyChanges {
                        target: xIconMC
                        //opacity:1.0
                    }
                }
            ]
            SequentialAnimation on color {
                running: true
                loops: Animation.Infinite
                PropertyAnimation {
                    target: co2;
                    property: "color"
                    from: 'red'
                    to: 'yellow'
                }
                PauseAnimation {
                    duration: 100
                }
                PropertyAnimation {
                    target: co2;
                    property: "color"
                    from: 'yellow'
                    to: 'red'
                }
            }
            Behavior on width{NumberAnimation{duration: 250;easing.type: Easing.InOutQuad}}
            Image {
                id: img2
                source: "./resources/imgs/signos/"+r.isMC+".svg"
                width: parent.width*0.65
                height: width
                anchors.centerIn: parent
            }

            ColorOverlay {
                id: co2
                anchors.fill: img2
                source: img2
                color: 'red'
            }
            Text{
                text: 'MC '+app.signos[r.isMC]
                font.pixelSize: sweg.fs*0.5
                color: 'white'
                width: contentWidth
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                anchors.rightMargin: sweg.fs*0.1
                Rectangle{
                    width: parent.contentWidth+3
                    height: parent.contentHeight+3
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: sweg.fs*0.1
                    z: parent.z-1
                    opacity: 0.5
                    antialiasing: true
                    anchors.centerIn: parent
                }
            }
            Text{
                text: '°'+r.gdegMC+' \''+r.mdegMC+''
                font.pixelSize: sweg.fs*0.5
                color: 'white'
                width: contentWidth// sweg.fs*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.right
                anchors.leftMargin: sweg.fs*0.1
                Rectangle{
                    width: parent.contentWidth+3
                    height: parent.contentHeight+3
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: sweg.fs*0.1
                    z: parent.z-1
                    opacity: 0.5
                    antialiasing: true
                    anchors.centerIn: parent
                }
            }
        }
    }
    function loadJson(jsonData) {
        let o1=jsonData.ph['h1']
        r.isAsc=o1.is
        r.gdegAsc=o1.rsgdeg
        r.mdegAsc=o1.mdeg
        app.uAscDegree=o1.rsgdeg

        let degs=(30*o1.is)+o1.rsgdeg
        o1=jsonData.ph['h10']
        r.isMC=o1.is
        r.gdegMC=o1.rsgdeg
        r.mdegMC=o1.mdeg
        app.uMcDegree=o1.rsgdeg
        ejeMC.rotation=degs-360-o1.gdeg
        xIconMC.rotation=0-ejeMC.rotation
    }
}
