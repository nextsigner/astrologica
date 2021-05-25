import QtQuick 2.0
//import QtGraphicalEffects 1.0

Item {
    id: r
    //width: housesCircle.currentHouse!==n?xArcs.width:xArcs.width+app.fs*2
    width: xArcs.width
    property real wg: 0.0
    property int gr: 0
    property int n: -1
    property int w: housesCircle.currentHouse!==n?app.fs*2.3:app.fs*5
    property int c: 0
    property var colors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    property bool showBorder: false
    property bool selected: housesCircle.currentHouse===n
    property  real op: 100.0
    property int opacitySpeed: 100
    Behavior on w{NumberAnimation{duration: 500}}
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
    Rectangle{
        id: ejeV
        width: r.width+app.fs*2
        height: 4
        color: 'transparent'
        anchors.centerIn: r
        Rectangle{
            width: app.fs+app.fs*0.15
            height: 4
            color: r.colors[r.c]
            Rectangle{
                width: app.fs*0.75
                height: width
                radius: width*0.5
                color: parent.color
                border.width: 2
                border.color: 'white'
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
                /*Image {
                    id: img
                    source: "./resources/imgs/casa.svg"
                    width: parent.width*1.6
                    height: width
                    anchors.centerIn: parent
                    //anchors.horizontalCenterOffset: app.fs*0.03
                    //anchors.verticalCenterOffset: 0-app.fs*0.03
                    rotation: 90-r.rotation-parent.rotation
                    //visible: false
                }
                ColorOverlay {
                    id: co1
                    anchors.fill: img
                    source: img
                    color: "#ffffff"
                    rotation: img.rotation
                }
                ColorOverlay {
                    id: co
                    anchors.fill: img
                    source: img
                    color: r.colors[r.c]//"#ffffff"
                    rotation: img.rotation
                    SequentialAnimation{
                        running: true
                        loops: Animation.Infinite
                        PropertyAnimation {
                            target: co
                            properties: "opacity"
                            from: 0.0
                            to: 1.0
                        }

                        PauseAnimation {
                            duration: 500
                        }
                        PropertyAnimation {
                            target: co
                            properties: "opacity"
                            from: 1.0
                            to: 0.0
                        }
                    }
                }
                */
                Text{
                    text: '<b>'+r.n+'</b>'
                    //text: ''+r.n
                    font.pixelSize: parent.width*0.8
                    width: contentWidth
                    height: contentHeight
                    horizontalAlignment: Text.AlignHCenter
                    //color: r.colors[r.c]
                    anchors.centerIn: parent
                    //anchors.horizontalCenterOffset: 0-app.fs*0.03
                    //anchors.verticalCenterOffset: app.fs*0.03
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
            ctx.reset();
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            //var radius = canvas.width*0.5-r.w*0.5;
            var rad=parseInt(canvas.width*0.5-r.w*0.5)
            //console.log('Rad: '+rad)
            var radius = rad>0?rad:r.width;
            ctx.beginPath();
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
        width: r.width//-app.fs
        height: width
        onPaint:{            
            var ctx = canvas2.getContext('2d')
            ctx.reset();
            var x = canvas2.width*0.5+app.fs*0.1;
            var y = canvas2.height*0.5//-app.fs;
            //var radius = canvas2.width*0.5//-r.w*0.5;
            var rad=parseInt(canvas.width*0.5)
            //console.log('Rad: '+rad)
            var radius = rad>0?rad:r.width;

            ctx.beginPath();
            ctx.arc(x, y, radius, ((2 * Math.PI) / 360 * 180)-(2 * Math.PI) / 360 * r.wg, (2 * Math.PI) / 360 * 180);
            ctx.lineWidth = app.fs*0.1;
            ctx.strokeStyle = r.colors[r.c];
            ctx.stroke();
        }
        function clear_canvas() {
            //var ctx = getContext("2d");
            //ctx.reset();
            canvas2.requestPaint();
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
