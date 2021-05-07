import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    id: r
    property int wg: 0
    property int gr: 0
    property int n: -1
    property int w: app.fs*2.3
    property int c: 0
    property var colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
    property bool selected: false
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
        width: r.width+app.fs*2
        height: 4
        color: 'transparent'
        anchors.centerIn: r
        Rectangle{
            //width: r.width/2+app.fs*0.5
            width: app.fs+app.fs*0.15
            height: 4
            color: r.colors[r.c]
            anchors.centerIn: r
            Rectangle{
                width: app.fs*0.75
                height: width
                radius: width*0.5
                color: parent.color
                anchors.verticalCenter: parent.verticalCenter
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(tc.running){
                            r.selected=false//!r.selected
                        }else{
                            r.selected=!r.selected
                        }
                        canvas.opacity=r.selected?1.0:0.65
                    }
                }
                Text{
                    text: '<b>'+r.n+'</b>'
                    font.pixelSize: parent.width*0.8
                    //color: r.colors[r.c]
                    anchors.centerIn: parent
                    rotation: 90-r.rotation-parent.rotation
                }
            }
        }
    }
    Canvas {
        id:canvas
        width: r.width//-app.fs
        height: width
        opacity: 0.65//r.selected?1.0:0.5
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
    Canvas {
        id:canvas2
        width: r.width//-app.fs
        height: width
        onPaint:{
            var ctx = canvas2.getContext('2d');
            var x = canvas2.width*0.5+app.fs*0.1;
            var y = canvas2.height*0.5//-app.fs;
            var radius = canvas2.width*0.5//-r.w*0.5;
            ctx.beginPath();
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = app.fs*0.1;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
    }
    Rectangle{
        id: ejeCentro
        width: canvas.width
        height: 4
        color: 'blue'//'transparent'
        anchors.centerIn: r
        rotation: 0-r.wg/2
        visible:false
        Rectangle{
            width: app.fs*3
            height: width
            //x:(r.w-width)/2
            border.width: 2
            border.color: 'white'
            radius: width*0.5
            color: 'red'//r.colors[r.c]
            anchors.verticalCenter: parent.verticalCenter
            rotation: 90-r.rotation-parent.rotation
            //anchors.left: parent.left
            //anchors.leftMargin: 0-width
            Text {
                text: '<b>'+r.n+'</b>'
                font.pixelSize: parent.width*0.8
                anchors.centerIn: parent
                color: 'white'
            }
        }
    }
    Timer{
        id: tc
        running: r.selected
        repeat: true
        interval: 350
        onTriggered: {
            canvas.opacity=canvas.opacity===1.0?0.65:1.0
        }
    }
}
