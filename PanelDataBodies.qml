import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12

Rectangle {
    id: r
    width: parent.width*0.25
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    state: 'hide'
    property alias currentIndex: lv.currentIndex
    property int currentIndexSign: -1
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:r.parent.width-r.width
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:r.parent.width
            }
        }
    ]
    Behavior on x{NumberAnimation{duration: 250}}
    onStateChanged: {
        //if(state==='hide')txtDataSearch.focus=false
        //xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            txtDataSearch.selectAll()
            txtDataSearch.focus=true
        }
    }
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        ListView{
            id: lv
            width: r.width
            height: r.height
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: compItemList
            model: lm
            currentIndex: app.currentPlanetIndex
            clip: true
            onCurrentIndexChanged: r.currentIndexSign=lm.get(currentIndex).is
        }
    }


    ListModel{
        id: lm
        function addItem(indexSign, stringData){
            return {
                is: indexSign,
                sd: stringData
            }
        }
    }
    Component{
        id: compItemList
        Rectangle{
            width: lv.width
            height: txtData.contentHeight+app.fs*0.1
            color: index===lv.currentIndex?'white':'black'
            border.width: index===lv.currentIndex?4:2
            border.color: 'white'
            Text {
                id: txtData
                text: sd
                font.pixelSize: app.fs*0.5
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                color: index===lv.currentIndex?'black':'white'
                anchors.centerIn: parent
            }
        }
    }
    function loadJson(json){
        lm.clear()
        let jo
        let o
       for(var i=0;i<15;i++){
           jo=json.pc['c'+i]
           let s = jo.nom+ ' °' +jo.rsgdeg+ '\'' +jo.mdeg+ '\'\'' +jo.sdeg+ ' ' +app.signos[jo.is]+ '  - Casa ' +jo.ih
           //console.log('--->'+s)
           lm.append(lm.addItem(jo.is, s))
       }

    }
}
