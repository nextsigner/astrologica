import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    id: r
    property int gr: 0
    property int n: -1
    property int w: app.fs
    property int c: 0
    property var colors: ['red', '#DFB508', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
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
            var radius = canvas.width*0.5-r.w*0.5;
            var startAngle = 1.0 * Math.PI;
            var endAngle = 1.17 * Math.PI;
            var counterClockwise = false;
            ctx.beginPath();
            ctx.arc(x, y, radius, startAngle, endAngle, counterClockwise);
            ctx.lineWidth = r.w;
            // line color
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
    }

    Rectangle{
        width: r.width
        height: 8
        anchors.centerIn: r
        color: 'transparent'//'blue'
        rotation: 15
        Rectangle{
            id: xImg
            width: r.w
            height: width
            //border.width: 1
            color: 'transparent'
            anchors.verticalCenter: parent.verticalCenter
            rotation: 0-r.rotation-15-r.gr-90
            property bool resaltado: false

            MouseArea{
                anchors.fill: parent
                onClicked: parent.resaltado=!parent.resaltado
            }
            Image {
                id: iconoSigno
                source: "./resources/imgs/signos/"+parseInt(r.n - 1)+".png"
                width: !parent.resaltado?parent.width:parent.width*2
                height: width
                anchors.centerIn: parent
                Behavior on width{
                    NumberAnimation{duration: 250}
                }
            }
            ColorOverlay {
                anchors.fill: iconoSigno
                source: iconoSigno
                color: 'black'
                Rectangle{
                    width: parent.width*1.1
                    height: width
                    radius: width*0.5
                    border.width: 4
                    border.color: r.colors[r.c]
                    anchors.centerIn: parent
                    z: parent.z-1
                    opacity: parent.parent.resaltado?1.0:0.0
                    Behavior on opacity{
                        NumberAnimation{duration: 250}
                    }
                }
            }
        }
    }
}
