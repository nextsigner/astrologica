import QtQuick 2.0

Item{
    id: r
    width: parent.width-(r.fs*2*objData.p)
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

    Behavior on rotation {
        NumberAnimation{
            duration: 3000
            easing.type: Easing.InOutQuad
        }
    }

    Item{
        width: r.fs
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
            source: "./resources/imgs/planetas/"+r.astro+".svg"
            width: parent.width
            height: width
            anchors.centerIn: parent
            rotation: 0-parent.parent.rotation
        }
    }
    //    Text{
    //        font.pixelSize: 20
    //        text:  r.objData.h
    //        color: 'red'
    //    }
}
