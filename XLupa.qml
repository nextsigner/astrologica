import QtQuick 2.7
import QtGraphicalEffects 1.0
Item {
    id: r
    width: app.fs*4
    height: width
    property real zoom: 2.0
    property alias image:img
    property int mod: 0
    clip: true
    onModChanged: {
        if(mod===0){
            swegz.visible=false
        }
        if(mod===1){
            swegz.visible=true
        }
        if(mod===2){
            swegz.visible=true
        }
    }
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
        //radius: width*0.5
        color: 'transparent'
        border.width: 3
        border.color: 'white'
    }
    Timer{
        id: tScreenShot
        running: img.visible || xViewLupa.visible
        repeat: true
        interval: 100
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
