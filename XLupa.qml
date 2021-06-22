import QtQuick 2.7
import QtGraphicalEffects 1.0
Item {
    id: r
    width: app.fs*4
    height: width
    y: parent.height*0.5-r.width*0.5
    x: parent.width*0.5-r.height*0.5
    property real zoom: 2.0
    property alias image:img
    property int mod: 2
    clip: true
    onModChanged: {
        if(mod===0){
            swegz.state='hide'
        }
        if(mod===1){
            swegz.state='show'
        }
        if(mod===2){
            swegz.state='show'
        }
    }
    Behavior on x{NumberAnimation{duration: 1000;easing.type: Easing.OutQuad}}
    Behavior on y{NumberAnimation{duration: 1000;easing.type: Easing.OutQuad}}
    MouseArea{
        anchors.fill: r
        drag.axis: Drag.XAndYAxis
        drag.target: r
        onClicked: {
            if(mod===0){
                mod=1
                return
            }
            if(mod===1){
                mod=2
                return
            }
            if(mod===2){
                mod=0
                return
            }
        }
    }
    Rectangle{
        id: bg
        anchors.fill: r
        color: 'black'
        visible: img.visible
    }
    Image {
        id: img
        x:0-r.x*r.zoom+xApp.width*(r.zoom*0.25)-r.width*0.5
        y: 0-r.y*r.zoom+xApp.height*(r.zoom*0.25)-r.width*0.5
        width: xApp.width
        height: xApp.height
        scale: r.zoom
        visible: r.mod!==2
    }
    Rectangle {
        id: mask
        width: 100
        height: 50
        //radius: width*0.5
        visible: false
    }
    Rectangle{
        id: borde
        anchors.fill: r
        radius: r.mod===2?width*0.5:0
        color: 'transparent'
        border.width: 3
        border.color: 'white'
    }
    Timer{
        id: tScreenShot
        running: img.visible
        repeat: true
        interval: 1
        onTriggered: {
            tScreenShot.stop()
            xApp.grabToImage(function(result) {
                //console.log('Url: '+result.url)
                img.source=result.url
                tScreenShot.restart()
            });
        }
    }
}
