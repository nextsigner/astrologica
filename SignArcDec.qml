import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: r
    property int gr: 0
    property int n: -1
    property int w: signCircle.w*0.25
    property color c
    property bool showBorder: false
    //Behavior on w{NumberAnimation{duration: sweg.speedRotation}}
    onWidthChanged: canvas.requestPaint()

    //    state: sweg.state
    //    states: [
    //        State {
    //            name: sweg.aStates[0]
    //            PropertyChanges {
    //                target: r
    //                w: sweg.fs*0.25
    //            }
    //        },
    //        State {
    //            name: sweg.aStates[1]
    //            PropertyChanges {
    //                target: r
    //                w: sweg.fs*0.5
    //            }

    //        },
    //        State {
    //            name: sweg.aStates[2]
    //            PropertyChanges {
    //                target: r
    //                w: sweg.fs*0.5
    //            }
    //        }
    //    ]

    Rectangle{
        anchors.fill: r
        color: 'transparent'
        border.width: 1
        border.color: 'red'
        radius: width*0.5
        visible: r.showBorder
    }
    Canvas {
        id:canvas
        width: r.width//-sweg.fs
        height: width
        //rotation: 0.5
        onPaint:{
            var ctx = canvas.getContext('2d');
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            //var rad=parseInt(canvas.width*0.5-r.w*0.5)
            //var radius = rad>0?rad:r.width;
            var radius=r.width*0.5-r.w*1.5
            ejeIcon.width=radius*2
            var startAngle = 1.0 * Math.PI;
            var endAngle = 1.056 * Math.PI;
            var counterClockwise = false;
            ctx.beginPath();
            ctx.arc(x, y, radius, startAngle, endAngle, counterClockwise);
            ctx.lineWidth = r.w;
            // line color
            ctx.strokeStyle = r.c
            ctx.stroke();
        }
    }

    Rectangle{
        id: ejeIcon
        width: r.width//-((r.w-xImg.width)/2)
        height: 8
        anchors.centerIn: r
        color: 'transparent'
        rotation: 5
        antialiasing: true
        Item{
            id: xImg
            width: r.w
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            rotation: 0-r.rotation-5-r.gr//-90
            antialiasing: true
            property bool resaltado: false//panelDataBodies.currentIndexSign === r.n - 1
            Image {
                id: iconoSigno
                source: "./resources/imgs/signos/"+r.n+".svg"
                property int w: xImg.width*0.75
                width: xImg.width//!xImg.resaltado?r.w:r.w*2
                height: width
                anchors.centerIn: parent
                antialiasing: true
            }
        }
    }
}