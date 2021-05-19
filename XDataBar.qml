import QtQuick 2.7

Rectangle {
    id: r
    width: parent.width
    height: app.fs*1.1
    color: 'black'
    border.width: 1
    border.color: 'white'
    property alias fileData: txtCurrentData.text
    property alias currentDateText: txtCurrentDate.text
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
        if(state==='show')tHide.restart()
    }
    Timer{
        id: tHide
        running: false
        repeat: false
        interval: 15*1000
        onTriggered: r.state='hide'
    }
    Row{
        id: row
        spacing: app.fs*0.5
        y:(parent.height-height)/2
        x: app.fs*0.25
        Rectangle{
            width: app.fs*0.5
            height: width
            radius: width*0.5
            color: app.fileData===app.currentData?'gray':'red'
            border.width: 2
            border.color: 'white'
            anchors.verticalCenter: parent
            y:(parent.height-height)/2
            MouseArea{
                anchors.fill: parent
                enabled: app.fileData!==app.currentData
                onClicked: {
                    app.saveJson()
                }
            }
        }
        Text {
            id: txtCurrentData
            text: 'Astrológica by @nextsigner'
            font.pixelSize: app.fs*0.5
            height: app.fs*0.5
            color: 'white'
            textFormat: Text.RichText
            y:(parent.height-height)/2
        }
    }
    Rectangle{
        width: txtCurrentDate.contentWidth+app.fs*0.5
        height: txtCurrentDate.contentHeight+app.fs*0.5
        color: 'black'
        border.width: 1
        border.color: 'white'
        y:parent.height
        visible: app.fileData!==app.currentData
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
}
