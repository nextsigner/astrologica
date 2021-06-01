import QtQuick 2.0
//import QtGraphicalEffects 1.0

Item {
    id: r
    width: housesCircle.currentHouse!==n?xArcs.width:xArcs.width+app.fs*2.5
    //width: xArcs.width
    anchors.centerIn: parent
    property real wg: 0.0
    property int wb: 3
    property int gr: 0
    property int n: -1
    property int w: housesCircle.currentHouse!==n?housesCircle.w*0.5:app.fs*6.5
    property int c: 0
    property var colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
    property bool selected: housesCircle.currentHouse===n
    property  real op: 100.0
    property int opacitySpeed: 100
    Behavior on w{NumberAnimation{duration: 500}}
    Behavior on width{NumberAnimation{duration:500}}

    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: ejeV
                width:  r.width+app.fs
            }
            PropertyChanges {
                target: canvas2
                opacity:  0.0
            }
            PropertyChanges {
                target: r
                colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: ejeV
                width:  r.width+app.fs*2.5
            }
            PropertyChanges {
                target: canvas2
                opacity:  1.0
            }
            PropertyChanges {
                target: r
                colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: ejeV
                width:  r.width+app.fs
            }
            PropertyChanges {
                target: canvas2
                opacity:  0.0
            }
            PropertyChanges {
                target: r
                colors: ['#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A', '#685E05', '#4B450A']
            }
        }
    ]

    onWidthChanged: {
        canvas.anchors.centerIn= r
        canvas2.anchors.centerIn= r
        canvas.requestPaint()
        canvas2.requestPaint()
    }
    onWChanged: {
        canvas.requestPaint()
        canvas2.requestPaint()
    }
    onOpChanged: {
        if(op===0.0){
            opacitySpeed=50
            r.opacity=0.0
        }
        if(op===1.0){
            opacitySpeed=500
            r.opacity=1.0
        }
    }
    onOpacityChanged:{
        if(opacity===0.0){
            r.op=1.0
        }
        tOp.restart()
    }
    Timer{
        id: tOp
        running: false
        repeat: true
        interval: 500
        onTriggered: r.opacity=1.0
    }
    Behavior on opacity{
        NumberAnimation{duration: r.opacitySpeed}
    }
    onRotationChanged: {
        canvas.clear_canvas()
        canvas.requestPaint()
        canvas2.clear_canvas()
        canvas2.requestPaint()
    }
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
        opacity: 0.65
        onPaint:{
            var ctx = canvas.getContext('2d');
            ctx.reset();
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            //var radius = canvas.width*0.5-r.w*0.5;
            var rad=parseInt(canvas.width*0.5-r.w*0.5)

            //console.log('Rad: '+rad)
            var radius = rad>0?rad:r.width;
            ctx.beginPath();
            /*if(r.n===12){
                ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * (r.wg-1.5), (2 * Math.PI) / 360 * 180);
            }else{
                ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            }*/
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = r.w;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
        function clear_canvas() {
            //var ctx = canvas.getContext("2d");
            //ctx.reset();
            canvas.requestPaint();
        }
    }
    Canvas {
        id:canvas2
        width: r.width
        height: width
        opacity: canvas.opacity
        onPaint:{
            var ctx = canvas2.getContext('2d')
            ctx.reset();
            var x = canvas2.width*0.5+r.wb;
            var y = canvas2.height*0.5
            var rad=parseInt(canvas.width*0.5)
            var radius = rad>0?rad:r.width;

            ctx.beginPath();
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = r.wb;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
        function clear_canvas() {
            canvas2.requestPaint();
        }
    }
    Rectangle{
        id: ejeV
        //width: r.width+app.fs*2.5
        height: r.wb
        color: 'transparent'
        anchors.centerIn: r
        opacity: housesCircle.currentHouse===n?canvas.opacity:1.0
        Row{
            anchors.left: circleBot.right
            Rectangle{
                id: lineaEje
                width: ((ejeV.width-r.width)*0.5-circleBot.width)
                height: r.wb
                color: r.colors[r.c]
            }
            Rectangle{
                id: lineaEje2
                width: r.w
                height: r.wb
                color: r.colors[r.c]
            }
        }
        Rectangle{
            id: circleBot
            width: app.fs*0.75+r.wb*2
            height: width
            radius: width*0.5
            color: 'black'
            border.width: r.wb
            border.color: lineaEje.color
            anchors.verticalCenter: parent.verticalCenter
            state: sweg.state
            states: [
                State {
                    name: sweg.aStates[0]
                    PropertyChanges {
                        target: circleBot
                        width: app.fs*0.25+r.wb*2
                        border.width: r.wb*0.25
                    }
                },
                State {
                    name: sweg.aStates[1]
                    PropertyChanges {
                        target: circleBot
                        width: app.fs*0.75+r.wb*2
                        border.width: r.wb
                    }
                },
                State {
                    name: sweg.aStates[2]
                    PropertyChanges {
                        target: circleBot
                        width: app.fs*0.25+r.wb*2
                        border.width: r.wb*0.25
                    }
                }
            ]
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
                font.pixelSize: parent.width*0.7
                width: contentWidth
                height: contentHeight
                horizontalAlignment: Text.AlignHCenter
                color: r.colors[r.c]
                anchors.centerIn: parent
                //anchors.horizontalCenterOffset: 0-app.fs*0.03
                //anchors.verticalCenterOffset: app.fs*0.03
                rotation: 90-r.rotation-parent.rotation
            }
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
    function refresh(){
        canvas.clear_canvas()
        canvas.requestPaint()
        canvas.update()

        canvas2.clear_canvas()
        canvas2.requestPaint()
        canvas2.update()
    }
}
