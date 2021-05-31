import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: r
    property int gr: 0
    property int n: -1
    property int w: 10
    property int c: 0
    //property var colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
    Behavior on w{NumberAnimation{duration: sweg.speedRotation}}
    Rectangle{
        anchors.fill: r
        color: 'transparent'
        border.width: 2
        border.color: 'red'
        radius: width*0.5
        visible: r.showBorder
    }
    Canvas {
        id:canvas
        width: r.width//-app.fs
        height: width
        onPaint:{
            var ctx = canvas.getContext('2d');
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            var rad=parseInt(canvas.width*0.5-r.w*0.5)
            var radius = rad>0?rad:r.width;

            var startAngle = 1.0 * Math.PI;
            var endAngle = 1.17 * Math.PI;
            var counterClockwise = false;
            ctx.beginPath();
            ctx.arc(x, y, radius, startAngle, endAngle, counterClockwise);
            ctx.lineWidth = r.w;
            // line color
            ctx.strokeStyle = app.signColors[r.c];
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
            rotation: 0-r.rotation-15-r.gr//-90
            antialiasing: true
            property bool resaltado: false//panelDataBodies.currentIndexSign === r.n - 1

            MouseArea{
                anchors.fill: parent
                onClicked: parent.resaltado=!parent.resaltado
            }
            Rectangle{
                width: xImg.width*3
                height: width
                radius: width*0.5
                border.width: 4
                border.color: app.signColors[r.c]
                anchors.centerIn: parent
                z: parent.z-1
                opacity: xImg.resaltado?1.0:0.0
                Behavior on opacity{
                    NumberAnimation{duration: 350}
                }
                Rectangle{
                    anchors.fill: parent
                    color: app.signColors[c]
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
