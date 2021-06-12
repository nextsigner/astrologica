import QtQuick 2.0
//import QtGraphicalEffects 1.0
import "./ss" as SS
Item {
    id: r
    anchors.fill: parent
    property int w: 500
    property alias ssp: ssPlanets
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: ssPlanets
                ds.value: 3
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
        }
    ]
    SS.Planets{
        id: ssPlanets
        canvas3dX: 0
        canvas3dY: 0
        canvas3dWidth: r.width
        canvas3dHeight: r.height
        radius: width*0.5
        //z:parent.z-1
        width: r.width
        height: r.height
        anchors.centerIn: parent
        //visible: false
        //focusedPlanet: 6
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "black"
        visible: false
    }
}
