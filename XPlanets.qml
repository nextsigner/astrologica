import QtQuick 2.0
//import QtGraphicalEffects 1.0
import "./ss" as SS
Item {
    id: r
    anchors.fill: parent
    property int w: 500
    property alias ssp: ssPlanets
    SS.Planets{
        id: ssPlanets
        canvas3dX: 0//r.width/2
        canvas3dY: 0
        canvas3dWidth: r.width
        canvas3dHeight: r.height
        radius: width*0.5
        //z:parent.z-1
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

/*Item {
    id: r
    anchors.fill: parent
    property int w: 500
    property alias ssp: ssPlanets
    Rectangle {
        id: bg
        anchors.fill: parent
        color: "black"
        visible: false
        SS.Planets{
            id: ssPlanets
            canvas3dX: 0//r.width/2
            canvas3dY: 0
            canvas3dWidth: r.width
            canvas3dHeight: r.height
            radius: width*0.5
            //z:parent.z-1
            anchors.centerIn: parent
            //visible: false
            //focusedPlanet: 6
        }
    }
    Rectangle {
        id: cutout
        width: r.w
        height: width
        //radius: width*0.5
        anchors.centerIn: parent

    }


    OpacityMask {
        width: r.width
        height: r.height
        anchors.centerIn: r
        source: bg
        maskSource: cutout
        invert: false
    }
}*/
