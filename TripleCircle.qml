import QtQuick 2.0

Item {
    id: r
    width: app.fs*6
    height: width
    anchors.centerIn: parent
    z:r.parent.z-1
    property int is: -1
    property int gdeg: -1
    property int mdeg: -1
    property int sdeg: -1
    property int rsgdeg: -1
    property int ih: -1
    property bool expand: false
    Rectangle{
        width: r.expand?r.width-circle1.width:app.fs
        height: 2
        anchors.centerIn: parent
        color: 'transparent'
        rotation: -120+60
        Behavior on width{
            NumberAnimation{duration: 1000}
        }
        Rectangle{
            id: circle1
            width: app.fs*1.5
            height: width
            radius: width*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            color: 'white'
            Image {
                id: img1
                source: "./resources/imgs/signos/"+r.is+".svg"
                width: parent.width*0.9
                height: width
                anchors.centerIn: parent
                rotation: r.gdeg+120-30
            }
        }
    }
    Rectangle{
        width: r.expand?r.width-circle1.width:app.fs
        height: 2
        anchors.centerIn: parent
        color: 'transparent'
        rotation: -240+60
        Behavior on width{
            NumberAnimation{duration: 1000}
        }
        Rectangle{
            id: circle2
            width: app.fs*1.5
            height: width
            radius: width*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            Image {
                id: img2
                source: "./resources/imgs/casa.svg"
                width: parent.width
                height: width
                //anchors.centerIn: parent
                //anchors.horizontalCenterOffset: 0-parent.width*0.05
                //anchors.verticalCenterOffset: 0-parent.width*0.025
                rotation: r.gdeg+240-30
            }
            Text{
                font.pixelSize: r.ih<=9?app.fs:app.fs*0.7
                text: '<b>'+r.ih+'</b>'
                color: 'white'
                anchors.centerIn: parent
                rotation: r.gdeg+240-30
            }
        }
    }
    Rectangle{
        width: r.expand?r.width-circle1.width:app.fs
        height: 2
        anchors.centerIn: parent
        color: 'transparent'
        rotation: 0+60
        Behavior on width{
            NumberAnimation{duration: 1000}
        }
        Rectangle{
            id: circle3
            width: app.fs*1.5
            height: width
            radius: width*0.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            Row{
                anchors.centerIn: parent
                rotation: r.gdeg+0-30
                Text{
                    font.pixelSize: app.fs*0.7
                    text: '<b>°'+r.rsgdeg+'</b>'
                }
                Text{
                    font.pixelSize: app.fs*0.45
                    text: '<b>\''+r.mdeg+'</b>'

                }
            }
        }
    }
}
