import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    anchors.bottom: parent.bottom
    color: 'black'
    border.width: 2
    border.color: 'white'
    state: 'hide'
    property bool enableLoadSign: true
    property alias currentIndex: lv.currentIndex
    Behavior on height{enabled: app.enableAn;NumberAnimation{duration:app.msDesDuration;easing.type: Easing.InOutQuad}}
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
    Behavior on x{enabled: app.enableAn;NumberAnimation{duration: app.msDesDuration}}
    onStateChanged: {
        //if(state==='hide')txtDataSearch.focus=false
        //xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
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
            currentIndex: app.currentSignIndex
            clip: true
            onCurrentIndexChanged: {
                if(!r.enableLoadSign){
                    r.enableLoadSign=true
                    return
                }
                if(currentIndex<12&&panelZonaMes.state==='hide'){
                    let joPar=app.currentJsonSignData.params
                    if(!app.currentJsonSignData.fechas)return
                    let jo=app.currentJsonSignData.fechas['is'+currentIndex]
                    //let s = app.signos[i]+ ' '+jo.d+'/'+jo.m+'/'+jo.a+' '+jo.h+':'+jo.min
                    let jsonCode='{"params":{"ms":100,"n":"Ahora Pampa Argentina","d":'+jo.d+',"m":'+jo.m+',"a":'+jo.a+',"h":'+jo.h+',"min":'+jo.min+',"gmt":'+joPar.gmt+',"lat":'+joPar.lat+',"lon":'+joPar.lon+',"ciudad":"Provincia de La Pampa Argentina"}}'
                    app.currentData=jsonCode
                    JS.runJsonTemp()
                }
            }
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
       for(var i=0;i<12;i++){
           jo=json.fechas['is'+i]
           let s = app.signos[i]+ ' '+jo.d+'/'+jo.m+'/'+jo.a+' '+jo.h+':'+jo.min
           lm.append(lm.addItem('a', s))
       }
       //lv.currentIndex=0
        r.state='show'
    }
    function copyPlanetsForPron(json){
        lm.clear()
        let jo
        let o
       for(var i=0;i<12;i++){
           jo=json.fechas['is'+i]
           let s = app.signos[i]+ ' '+jo.d+'/'+jo.m+'/'+jo.a+' '+jo.h+':'+jo.min
           lm.append(lm.addItem('a', s))
       }
       //lv.currentIndex=0
        r.state='show'
    }
}
