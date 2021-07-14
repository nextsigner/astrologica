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
    property int currentIndexSign: -1
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
    Behavior on x{NumberAnimation{duration: app.msDesDuration}}
    Behavior on height{NumberAnimation{duration: app.msDesDuration}}
    Settings{
        id: s
        fileName: 'zm.cfg'
        property int currentYear: -1
        property int currentMonth: -1
        property int currentQ: -1
    }
    onCurrentIndexSignChanged: {
        let joPar=app.currentJsonSignData.params
        if(!app.currentJsonSignData.fechas)return
        let jo=app.currentJsonSignData.fechas['is'+r.currentIndexSign]
        //let s = app.signos[i]+ ' '+jo.d+'/'+jo.m+'/'+jo.a+' '+jo.h+':'+jo.min
        let jsonCode='{"params":{"ms":100,"n":"Ahora Pampa Argentina","d":'+jo.d+',"m":'+jo.m+',"a":'+jo.a+',"h":'+jo.h+',"min":'+jo.min+',"gmt":'+joPar.gmt+',"lat":'+joPar.lat+',"lon":'+joPar.lon+',"ciudad":"Provincia de La Pampa Argentina"}}'
        //JS.setTitleData(r.currentCity, s.currentQ===1?1:15, s.currentMonth, s.currentYear, jo.h, jo.min, jo.gmt, '', jo.lat, jo.lon, 0)
        console.log('jsonCode:'+jsonCode)
        app.currentData=jsonCode
        JS.runJsonTemp()
    }
    Audio {
        id: mp;
        property int currentIndex: -1
        onPlaybackStateChanged:{
            if(mp.playbackState===Audio.StoppedState){
                //playlist.removeItem(0)

                //currentIndex++
            }
            if(mp.playbackState===Audio.PlayingState){
                if(r.currentIndexSign<0){
                    //r.currentIndexSign=0
                }
                //console.log('playlist zm currentItemsource: '+currentIndex)
                //playlist.currentIndex=currentIndex

            }
        }
        playlist: Playlist {
            id: playlist
            onCurrentIndexChanged:{
                checkSource()
                //r.currentIndexSign=currentIndex
                /*if(currentIndex===0){
                    panelControlsSign.currentIndex=0
                    unik.speak('hello')
                }*/
                //panelControlsSign.currentIndex=currentIndex
                //r.currentIndex=currentIndex
                //panelDataBodies.state='hide'
//                if((''+currentItemSource).indexOf('&isFS=true')>=0){
//                    panelDataBodies.state='hide'
//                    //panelControlsSign.currentIndex++
//                }
            }
            onCurrentItemSourceChanged:{
                //panelDataBodies.state='hide'
                //                if(currentIndex===0){
                //                    unik.speak('en cero')
                //                }else{

//                if((''+currentItemSource).indexOf('&isFS=true')>=0){
//                    panelDataBodies.state='hide'
//                    //r.currentIndexSign++
//                    //panelControlsSign.currentIndex++
//                    //mp.currentIndex++
//                    //unik.speak('en uno uno uno.current')
//                }else{
//                    //unik.speak('en cero')
//                    //panelControlsSign.currentIndex=mp.currentIndex
//                }
                //}
                //console.log('currentItemsource :'+currentItemSource)
            }
            onItemCountChanged:{
                //xMsgList.actualizar(playlist)
            }
            function checkSource(){
//                if(r.currentIndexSign<0){
//                    r.currentIndexSign=0
//                }
                if((''+playlist.currentItemSource).indexOf('&isFS=true')>=0){
                    panelDataBodies.state='hide'
                    r.currentIndexSign++
                    //panelControlsSign.currentIndex++
                    //mp.currentIndex++
                    //unik.speak('en uno uno uno.current')
                }
                if((''+playlist.currentItemSource).indexOf('&isFZ=true')>=0){
                    panelDataBodies.state='hide'
                    r.currentIndexSign=-1
                    r.currentIndex++
                    //panelControlsSign.currentIndex++
                    //mp.currentIndex++
                    //unik.speak('en uno uno uno.current')
                }
            }
        }
        function addText(text, tipoLinea){
            let t=text
            t=t.replace(/ /g, '%20').replace(/_/g, ' ')
            //console.log('MSG: '+msg)
            let s='https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text='+t+'&voice=es-ES_EnriqueVoice&download=true&accept=audio%2Fmp3'
            if(tipoLinea===1)s+='&isFS=true'
            if(tipoLinea===2)s+='&isFZ=true'
            playlist.addItem(s)
        }
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
        ListView{
            id: lv
            width: r.width
            height: r.height-xTit.height
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: compItemList
            model: lm
            cacheBuffer: 150
            displayMarginBeginning: cacheBuffer*app.fs*3
            clip: true
            Behavior on contentY{NumberAnimation{duration: app.msDesDuration}}
            onCurrentIndexChanged: {
                contentY=lv.itemAtIndex(currentIndex).y+lv.itemAtIndex(currentIndex).height-r.height*0.5
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
        Rectangle{
            id: itemList
            width: lv.width-r.border.width*2
            height: txtData.contentHeight+app.fs//index!==lv.currentIndex?app.fs*1.5:app.fs*3.5//txtData.contentHeight+app.fs*0.1
            color: itemList.selected?'white':'black'
            border.width: itemList.selected?2:0
            border.color: 'red'
            opacity: itemList.selected?1.0:0.5
            property bool selected: lv.currentIndex===index
            property int is: -1
            anchors.horizontalCenter: parent.horizontalCenter
            onSelectedChanged: loadJsonTask()
            Behavior on opacity{NumberAnimation{duration: app.msDesDuration}}
            Column{
                anchors.centerIn: parent
                Rectangle{
                    id: txtInfoZona
                    width: itemList.width-app.fs*0.5
                    height: txtData.contentHeight+app.fs*0.25
                    color: !itemList.selected?'white':'black'
                    border.width: 1
                    border.color: 'white'
                    radius: app.fs*0.1
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: txtData
                        //text: (itemList.is!==-1?'<b>Ascendente '+app.signos[itemList.is]+'</b><br />':'')+dato
                        font.pixelSize: app.fs*0.35
                        width: parent.width
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        horizontalAlignment: Text.AlignHCenter
                        color:itemList.selected?'white':'black'
                        anchors.centerIn: parent
                    }
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    lv.currentIndex=index
                    //r.state='hide'
                    // xBottomBar.objPanelCmd.makeRS(itemList.rsDate)
                }
            }
            function loadJsonTask(){
                r.currentCity=json.nom
                r.currentLat=json.lat
                r.currentLon=json.lon
                r.currentGmt=json.gmt
                mp.stop()
                playlist.clear()
                //playlist.currentIndex=-1
                let fileName='./jsons/hm/'+json.id+'/q'+s.currentQ+'_'+s.currentMonth+'_'+s.currentYear+'.json'
                if(!unik.fileExist(fileName)){
                    console.log('El archivo '+fileName+' no está disponible.')
                    return
                }else{
                    //JS.setTitleData(json.nom, s.currentQ===1?1:15, s.currentMonth, s.currentYear, 0, 0, 0, json.des, json.lat, json.lon, 0)
                    //let j3='{"params":{"tipo": "pl", "ms":0,"n":"'+r.currentCity+'","d":1,"m":'+s.currentMonth+',"a":'+s.currentYear+',"h":0,"min":1,"gmt":'+json.gmt+',"lat":'+r.currentLat+',"lon":'+r.currentLon+',"ciudad":"'+r.currentCity+'"}}'
                    //sweg.loadSign(JSON.parse(j3))
                    let txtCab='Cargando signo'
                    mp.addText(txtCab, 1)
                    let jsonData=unik.getFile(fileName)
                    let j=JSON.parse(jsonData)
                    console.log('json task: '+JSON.stringify(j))
                    for(var i=0;i<Object.keys(j.signos).length;i++){
                        let title='Horóscopo para las personas nacidas en '+json.nom+' con el signo solar o ascendente '+app.signos[i]+'para el mes de '+app.meses[s.currentMonth]+' de '+s.currentYear
                        mp.addText(title, 0)
                        let t=j.signos['s'+parseInt(i + 1)].h
                        let pf=t.split('.')
                        for(var i2=0;i2<pf.length;i2++){
                            mp.addText(pf[i2], false)
                            /*if(i2!==pf.length-1){
                                mp.addText(pf[i2], false)
                            }else{
                                mp.addText(pf[i2], true)
                            }*/
                        }
                        let txtPie='Próximo signo'
                        if(i!==11){
                            txtPie='Próximo signo'
                            mp.addText(txtPie, 1)
                        }else{
                            txtPie='Fin del horóscopo para las personas nacidas en '+json.nom+' con el signo solar o ascendente '+app.signos[i]+'para el mes de '+app.meses[s.currentMonth]+' de '+s.currentYear
                            mp.addText(txtPie, 2)
                        }
                    }
                    /*let sj='{"params":{"tipo": "pl", "ms":0,"n":"'+r.currentCity+'","d":1,"m":'+s.currentMonth+',"a":'+s.currentYear+',"h":0,"min":0,"gmt":'+r.currentGmt+',"lat":'+r.currentLat+',"lon":'+r.currentLat+',"ciudad":"'+r.currentCity+'"}}'
                    let json2=JSON.parse(sj)
                    sweg.loadSign(json2)*/
                }
                sweg.loadSign(r.mkJsonSign(json))
                //panelControlsSign.currentIndex=1
                //mp.play()
            }

            Component.onCompleted: {
                //console.log('index '+index+': '+JSON.stringify(json))
                let fs1=parseInt(app.fs*0.75)
                let fs2=parseInt(fs1*0.6)
                let data='<b style="font-size:'+fs1+'px;">'+json['nom']+'</b><br/>'
                    +'<b style="font-size:'+fs2+'px;">'+json['des']+'</b>'
                txtData.text=data
            }
            Text {
                id: infoTXT
                text: '<b>'+r.currentIndexSign+'</b>'
                font.pixelSize: app.fs
                color: 'red'
                anchors.centerIn: parent
            }
        }
    }
    Item{id: xuqp}
    Component.onCompleted: {
        //loadZonas()
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
    function mkJsonSign(json){
        let dd = new Date(Date.now())
        let ms=dd.getTime()
        let nom='Centro de Argentina'
        let d=s.currentQ===1?1:15
        let m=s.currentMonth
        let a=s.currentYear
        let h=0
        let min=0
        let lat=json.lat
        let lon=json.lon
        let gmt=json.gmt
        let ciudad=' '
        let j='{"params":{"tipo": "pl", "ms":'+ms+',"n":"'+nom+'","d":'+d+',"m":'+m+',"a":'+a+',"h":'+h+',"min":'+min+',"gmt":'+gmt+',"lat":'+lat+',"lon":'+lon+',"ciudad":"'+ciudad+'"}}'
        return JSON.parse(j)
    }
    function loadZonas(){
        //panelControlsSign.currentIndex=5
        lm.clear()
        let fileName='./jsons/hm/zonas.json'
        let fileData=unik.getFile(fileName)
        //console.log('json zonas: '+fileData)
        let j=JSON.parse(fileData)
        for(var i=0;i<Object.keys(j.zonas).length;i++){
            lm.append(lm.addItem(j['zonas']['z'+parseInt(i+1)]))
        }
    }
}
