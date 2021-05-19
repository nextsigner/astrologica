import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12

Rectangle {
    id: r
    width: parent.width*0.3
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    state: 'hide'
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
            clip: true
        }
    }


    ListModel{
        id: lm
        function addItem(vFileName, vData){
            return {
                fileName: vFileName,
                dato: vData
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
                text: dato
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
           let s = jo.nom+ ' °' +jo.rsgdeg+ '\'' +jo.mdeg+ '\'\'' +jo.sdeg+ ' ' +app.signos[jo.is]
           lm.append(lm.addItem('a', s))
       }

    }
}
