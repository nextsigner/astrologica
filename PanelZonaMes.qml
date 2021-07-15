import QtQuick 2.7
import QtQuick.Controls 2.0
import QtMultimedia 5.12
import Qt.labs.settings 1.1
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width
    height: parent.height
    color: 'black'
    //visible: false
    border.width: 2
    border.color: 'white'
    property alias currentIndex: lv.currentIndex
    property alias listModel: lm
    property string currentCity: ''
    property string uTit: '<b>Horóscopo Mensual</b>'
    property real currentLat: 0.000
    property real currentLon: 0.000
    property int currentGmt: -0
    property string currentIdZona: ''
    //property int currentIndexSign: -1
    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:0-r.width
            }
        }
    ]
    onStateChanged:{
        if(state==='hide'){
            detener()
            return
        }
        if(state==='show'){
            iniciar()
            return
        }
    }
    Behavior on x{NumberAnimation{duration: app.msDesDuration}}
    Behavior on height{NumberAnimation{duration: app.msDesDuration}}
    Settings{
        id: s
        fileName: 'zm.cfg'
        property int currentYear: -1
        property int currentMonth: -1
        property int currentQ: -1
    }

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id:xTit
            width: lv.width
            height: app.fs*1.5
            color: 'black'
            border.width: 2
            border.color: txtLabelTit.focus?'red':'white'
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtLabelTit
                text: r.uTit
                font.pixelSize: app.fs*0.5
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                color: 'white'
                focus: true
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    if(lm.count===0){
                        loadZonas()
                    }else{
                        mp.play()
                    }
                }
            }
        }
        Flickable {
            id: listController
            width: r.width
            height: lv.itemAtIndex(0).height//app.fs*4//lm.count>0?itemAtIndex(0).height:0//r.height-xTit.height
            contentWidth: r.width*lm.count
            contentHeight: r.height
            boundsBehavior: Flickable.StopAtBounds
            GridView{
                id: lv
                width: r.width//*lm.count
                height: app.fs*4//lm.count>0?itemAtIndex(0).height:0//r.height-xTit.height

                //anchors.horizontalCenter: parent.horizontalCenter
                delegate: compItemList
                model: lm
                //orientation: ListView.Horizontal
                cacheBuffer: 10
                displayMarginBeginning: cacheBuffer*app.fs*3
                clip: true
                cellWidth: r.width
                cellHeight: app.fs*4
                Behavior on contentY{NumberAnimation{duration: app.msDesDuration}}
                onCurrentIndexChanged: {
                    //contentY=0-lv.itemAtIndex(currentIndex).y//+r.height//+lv.itemAtIndex(currentIndex).height//-r.height//*0.5
                }
            }
        }
        Rectangle{
            width: r.width
            height: r.height-xTit.height-listController.height
            clip: true
            Repeater{
                id: repImgsZonas
                Image {
                    id: imgZona
                    source: "file:./resources/imgs/"+modelData+".png"
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    //scale: 1.2
                    opacity: modelData===r.currentIdZona
                    Behavior on opacity{NumberAnimation{duration: 500}}
                }
            }
        }
    }
    ListModel{
        id: lm
        function addItem(vJson){
            return {
                json: vJson
            }
        }
    }
    Component{
        id: compItemList
        XZm{
            onTaskFinished: {
                if(itemIndex<lm.count-1){
                    lv.currentIndex++
                }else{
                    lv.currentIndex=0
                }
            }
        }
    }
    Item{id: xuqp}
    Component.onCompleted: {
        loadZonas()
    }
    function setCurrentTime(q, m, y){
        s.currentQ=q
        s.currentMonth=m
        s.currentYear=y
        for(var i=0; i<lm.count;i++){
            if(lv.itemAtIndex(i).selected){
                lv.itemAtIndex(i).loadJsonTask()
                break
            }
        }
    }
    function loadZonas(){
        //panelControlsSign.currentIndex=5
        lm.clear()
        let fileName='./jsons/hm/zonas.json'
        let fileData=unik.getFile(fileName)
        //console.log('json zonas: '+fileData)
        let j=JSON.parse(fileData)
        let az=[]
        for(var i=0;i<Object.keys(j.zonas).length;i++){
            lm.append(lm.addItem(j['zonas']['z'+parseInt(i+1)]))
            az.push(j['zonas']['z'+parseInt(i+1)]['id'])
        }
        repImgsZonas.model=az
    }
    function pause(){
        if(lv.itemAtIndex(lv.currentIndex).pauded){
            lv.itemAtIndex(lv.currentIndex).pause()
        }else{
            lv.itemAtIndex(lv.currentIndex).play()
        }
    }
    function play(){
        lv.itemAtIndex(lv.currentIndex).play()
    }
    function stop(){
        lv.itemAtIndex(lv.currentIndex).stop()
    }
    function iniciar(){
        lv.itemAtIndex(0).loadJsonTask()
    }
    function detener(){
        lv.itemAtIndex(0).detener()
        r.currentIndex=0
    }
}
