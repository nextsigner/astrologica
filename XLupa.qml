import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    id: r
    width: app.fs*3
    height: width
    //border.width: 2
    //border.color: 'red'
    //radius: width*0.5
    //color: 'black'
    clip: true
    MouseArea{
        anchors.fill: r
        drag.axis: Drag.XAndYAxis
        drag.target: r

    }

    Image {
        id: img
        x:0-r.x+sweg.width*0.5+app.fs*0.17
        y: 0-r.y//+r.width//*0.5//-sweg.height*0.5//+app.fs
        width: sweg.width
        height: sweg.height
        visible: false
        //scale: 2.0
        //radius: width*0.5
        //source: "file"
        //anchors.centerIn: r

    }
    Rectangle{
        id: mask
        anchors.fill: r
        radius: width*0.5
        color: 'red'
        visible: false
    }
    OpacityMask {
        width: img.width
        height: img.height
        x: img.width*0.5+img.x*2-r.width*0.5//+sweg.width*0.5
        y:img.height*0.5+img.y*2-r.width*0.5
        source: img
        maskSource: mask
        opacity: 0.6
        scale: 2.0
    }
    Rectangle{
        id: borde
        anchors.fill: r
        radius: width*0.5
        color: 'transparent'
        border.width: 3
        border.color: 'white'
    }
    Timer{
        id: tScreenShot
        running: true
        repeat: true
        interval: 500
        onTriggered: {
            sweg.grabToImage(function(result) {
                //console.log('Url: '+result.url)
                img.source=result.url
                //result.saveToFile(name);
            });
        }
    }
}
