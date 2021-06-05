import QtQuick 2.0
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
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.width-app.fs*5
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: sweg.width-app.fs
            }
        }
    ]
    Rectangle{
        id: ejeAsc
        width: sweg.objSignsCircle.width
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        Rectangle{
            id: xIconAsc
            property bool selected: app.currentPlanetIndex===15
            width: selected?app.fs*2:app.fs
            height: width
            radius: width*0.5
            color: 'black'
            border.width: sweg.objHousesCircle.wb
            border.color: co.color
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
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
                spacing: app.fs*0.05
                Text{
                    text: 'Asc '+app.signos[r.isAsc]
                    font.pixelSize: app.fs*0.5
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
                        radius: app.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        anchors.centerIn: parent
                    }
                }
                Item{width: xIconAsc.width;height: width}
                Text{
                    text: '°'+r.gdegAsc+' \''+r.mdegAsc+''
                    font.pixelSize: app.fs*0.5
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
                        radius: app.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    Rectangle{
        id: ejeMC
        width: sweg.objSignsCircle.width
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        //        Rectangle{
        //            width: housesCircle.w*0.5
        //            height: housesCircle.wb
        //            //border.width: 1
        //            //border.color: 'yellow'
        //            anchors.verticalCenter: parent.verticalCenter
        //            color: app.signColors[0]
        //        }
        Rectangle{
            id: xIconMC
            property bool selected: app.currentPlanetIndex===16
            width: selected?app.fs*2:app.fs
            height: width
            radius: width*0.5
            color: 'black'
            border.width: sweg.objHousesCircle.wb
            border.color: co2.color
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: 0
            opacity: app.currentPlanetIndex!==16&&anchors.rightMargin===0?0.0:1.0
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
                        anchors.rightMargin: app.currentPlanetIndex===16?0- housesCircle.width*0.5-xIconMC.width*0.5:0
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
            Row{
                //anchors.centerIn: parent
                anchors.verticalCenter: parent.verticalCenter
                x:0-((width-parent.width)/2)-parent.width/2
                spacing: app.fs*0.05
                Text{
                    text: 'MC '+app.signos[r.isMC]
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    width: contentWidth//app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    Rectangle{
                        width: parent.contentWidth+3
                        height: parent.contentHeight+3
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: app.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        anchors.centerIn: parent
                    }
                }
                Item{width: xIconMC.width;height: width}
                Text{
                    text: '°'+r.gdegAsc+' \''+r.mdegAsc+''
                    font.pixelSize: app.fs*0.5
                    color: 'white'
                    width: contentWidth// app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    Rectangle{
                        width: parent.contentWidth+3
                        height: parent.contentHeight+3
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: app.fs*0.1
                        z: parent.z-1
                        opacity: 0.5
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    function loadJson(jsonData) {
        let o1=jsonData.ph['h1']
        r.isAsc=o1.is
        r.gdegAsc=o1.rsgdeg
        r.mdegAsc=o1.mdeg

        let degs=(30*o1.is)+o1.rsgdeg
        o1=jsonData.ph['h10']
        r.isMC=o1.is
        r.gdegMC=o1.rsgdeg
        r.mdegMC=o1.mdeg
        ejeMC.rotation=degs-360-o1.gdeg
        xIconMC.rotation=0-ejeMC.rotation
    }
}
