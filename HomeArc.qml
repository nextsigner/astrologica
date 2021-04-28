import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    id: r
    property int wg: 0
    property int gr: 0
    property int n: -1
    property int w: app.fs*2.3
    property int c: 0
    property var colors: ['#ff9933', '#99ff33']//['red', '#FBE103', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
    Rectangle{
        anchors.fill: r
        color: 'transparent'
        border.width: 2
        border.color: 'red'
        radius: width*0.5
        visible: r.showBorder
    }
    Rectangle{
        id: ejeV
        width: r.width+app.fs*4
        height: 4
        color: 'yellow'
        anchors.centerIn: r
        Rectangle{
            width: app.fs*0.5
            height: width
            radius: width*0.5
            color: parent.color
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Canvas {
        id:canvas
        width: r.width//-app.fs
        height: width
        onPaint:{
            var ctx = canvas.getContext('2d');
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            var radius = canvas.width*0.5-r.w*0.5;
            ctx.beginPath();
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = r.w;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
    }

    Rectangle{
        width: r.width//-((r.w-xImg.width)/2)
        height: 8
        anchors.centerIn: r
        color: 'transparent'//'blue'
        rotation: 15
        antialiasing: true
        Rectangle{
            id: xImg
            width: r.w
            height: width
            //border.width: 1
            color: 'transparent'
            anchors.verticalCenter: parent.verticalCenter
            rotation: 0-r.rotation-15-r.gr-90
            antialiasing: true
            property bool resaltado: false

            MouseArea{
                anchors.fill: parent
                onClicked: parent.resaltado=!parent.resaltado
            }
            Rectangle{
                width: xImg.width*3
                height: width
                radius: width*0.5
                border.width: 4
                border.color: r.colors[r.c]
                anchors.centerIn: parent
                z: parent.z-1
                opacity: xImg.resaltado?1.0:0.0
                Behavior on opacity{
                    NumberAnimation{duration: 350}
                }
                Rectangle{
                    anchors.fill: parent
                    color: colors[c]
                    radius: width*0.5
                    opacity: 0.35
                }
            }
            Column{
                anchors.centerIn: parent
                Text {
                    text: '<b>'+app.signos[r.n - 1]+'</b>'
                    font.pixelSize: r.w*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: xImg.resaltado
                    opacity: xImg.resaltado?1.0:0.0
                    Behavior on width{
                        NumberAnimation{duration: 350}
                    }
                }
                Image {
                    id: iconoSigno
                    source: "./resources/imgs/signos/"+parseInt(r.n - 1)+".svg"
                    property int w: xImg.width*0.75
                    width: !xImg.resaltado?w:w*2
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                    antialiasing: true
                    Behavior on width{
                        NumberAnimation{duration: 350}
                    }
                }
            }
        }
    }
}
