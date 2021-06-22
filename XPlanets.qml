import QtQuick 2.0
//import QtGraphicalEffects 1.0
import "./ss" as SS
Item {
    id: r
    anchors.fill: parent
    objectName: 'xplanets'
    property int w: 500
    property alias ssp: ssPlanets
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: ssPlanets
                ds.value: 6
                ss.value: 2000
                width: r.width//*2
                height: r.height//*2
                //canvas3dX:(r.width*2-r.width)/2
                //canvas3dY:(r.height*2-r.height)/2
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: ssPlanets
                ds.value: -3
                ss.value: 600
                width: r.width
                height: r.height
                //canvas3dX:0
                //canvas3dY:0
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: ssPlanets
                ds.value: -3
                ss.value: 600
                width: r.width
                height: r.height
                //canvas3dX:0
                //canvas3dY:0
            }
        },
        State {
            name: 'centrado'
            PropertyChanges {
                target: r
                anchors.horizontalCenterOffset: sweg.width*0.2
            }
        }
    ]
    SS.Planets{
        id: ssPlanets
        canvas3dX: 0-canvas3dWidth*0.25
        canvas3dY: 0-canvas3dHeight*0.25
        canvas3dWidth: r.width*2
        canvas3dHeight: r.height*2
        radius: width*0.5
        //z:parent.z-1
        width: r.width*2
        height: r.height*2
        anchors.centerIn: parent
        //scale: 0.5
        //visible: false
        //focusedPlanet: 6
        onFocusedPlanetChanged: {
            na1.duration=500
            na2.duration=500
            state='centrado'
            tDesCentrado.restart()
        }
        Behavior on anchors.horizontalCenterOffset{NumberAnimation{id: na1; duration: 2500}}
        Behavior on anchors.verticalCenterOffset{NumberAnimation{id: na2; duration: 2500}}
        state: 'descentrado'
        states: [
            State {
                name: 'descentrado'
                PropertyChanges {
                    target: ssPlanets
                    anchors.horizontalCenterOffset: 0-sweg.width*0.47
                    anchors.verticalCenterOffset: 0-sweg.height*0.35
                }
            },
            State {
                name: 'centrado'
                PropertyChanges {
                    target: ssPlanets
                    anchors.horizontalCenterOffset: 0
                    anchors.verticalCenterOffset: 0
                }
            }
        ]
        Timer{
            id: tDesCentrado
            running: false
            repeat: false
            interval: 5000
            onTriggered: {
                na1.duration=3000
                na2.duration=3000
                ssPlanets.state='descentrado'
            }
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "black"
        visible: false
    }
}
