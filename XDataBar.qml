import QtQuick 2.7
import "Funcs.js" as JS
import "./comps" as Comps
Rectangle {
    id: r
    width: parent.width
    height: app.fs*1.1
    color: 'black'
    border.width: 1
    border.color: 'white'
    property string titleData: txtCurrentData.text
    property alias currentDateText: txtCurrentDate.text
    property alias currentGmtText: txtCurrentGmt.text
    property bool showTimes: false
    state: 'hide'
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: r
                y:0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                y:0-r.height
            }
        }
    ]
    Behavior on y{NumberAnimation{duration:350;easing.type: Easing.InOutQuad}}
    onStateChanged: {
        //if(state==='show')tHide.restart()
    }
    onTitleDataChanged: {
        let a=titleData.split('|')
        rep.model=a
    }
    Timer{
        id: tHide
        running: false
        repeat: false
        interval: 15*1000
        //onTriggered: r.state='hide'
    }
    Row{
        id: row
        spacing: app.fs*0.15
        y:(parent.height-height)/2
        x: app.fs*0.25
        Rectangle{
            width: app.fs*0.5
            height: width
            radius: width*0.5
            color: app.fileData===app.currentData?'gray':'red'
            border.width: 2
            border.color: 'white'
            anchors.verticalCenter: parent.verticalCenter
            y:(parent.height-height)/2
            MouseArea{
                anchors.fill: parent
                enabled: app.titleData!==app.currentData
                onClicked: {
                    JS.saveJson()
                }
            }
        }
        Row{
            spacing: app.fs*0.15
            anchors.verticalCenter: parent.verticalCenter
            Repeater{
                id: rep
                Rectangle{
                    width: txtRow.contentWidth+app.fs*0.1
                    height: txtRow.contentHeight+app.fs*0.1
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: app.fs*0.1
                    Text{
                        id: txtRow
                        text: modelData//.replace(/_/g, ' ')
                        font.pixelSize: r.height*0.5
                        color: 'white'
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    Comps.XTimes{
        id: xTimes
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.1
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: yPos
    }
    Row{
        spacing: app.fs*0.5
        height: txtCurrentDate.contentHeight+app.fs*0.5
        y:parent.height
        visible: app.titleData!==app.currentData
        Rectangle{
            width: txtCurrentDate.contentWidth+app.fs*0.5
            height: txtCurrentDate.contentHeight+app.fs*0.5
            color: 'black'
            border.width: 1
            border.color: 'white'
            Text {
                id: txtCurrentDate
                text: '0/0/000 00:00'
                font.pixelSize: app.fs*0.5
                height: app.fs*0.5
                color: 'white'
                textFormat: Text.RichText
                anchors.centerIn: parent
            }
        }
        Rectangle{
            width: txtCurrentGmt.contentWidth+app.fs*0.5
            height: txtCurrentGmt.contentHeight+app.fs*0.5
            color: 'black'
            border.width: 1
            border.color: 'white'
            Text {
                id: txtCurrentGmt
                text: '?'
                font.pixelSize: app.fs*0.5
                height: app.fs*0.5
                color: 'white'
                textFormat: Text.RichText
                anchors.centerIn: parent
            }
            MouseArea {
                id: maw
                anchors.fill: parent
                onClicked: r.v=!r.v
                property int m:0
                property date uDate//: app.currentDate
                property int f: 0
                property int uY: 0
                onWheel: {
                    let v=[-11,-10,-9,-8,-7, -6, -5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12]
                    let ci=v.indexOf(app.currentGmt)
                    if(wheel.angleDelta.y===120){
                        if(ci<23){
                            ci++
                        }else{
                            ci=0
                        }
                    }else{
                        if(ci>0){
                            ci--
                        }else{
                            ci=23
                        }
                    }
                    app.currentGmt=v[ci]
                }
            }
        }
    }
}
