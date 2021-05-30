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
            currentIndex: app.currentSignIndex
            clip: true
            onCurrentIndexChanged: {
                if(currentIndex<12){
                    let joPar=app.currentJsonSignData.params
                    if(!app.currentJsonSignData.fechas)return
                    let jo=app.currentJsonSignData.fechas['is'+currentIndex]
                    //let s = app.signos[i]+ ' '+jo.d+'/'+jo.m+'/'+jo.a+' '+jo.h+':'+jo.min
                    let jsonCode='{"params":{"ms":100,"n":"Ahora Pampa Argentina","d":'+jo.d+',"m":'+jo.m+',"a":'+jo.a+',"h":'+jo.h+',"min":'+jo.min+',"gmt":'+joPar.gmt+',"lat":'+joPar.lat+',"lon":'+joPar.lon+',"ciudad":"Provincia de La Pampa Argentina"}}'
                    app.currentData=jsonCode
                    app.runJsonTemp()
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
    function loadSign(j){
        console.log('Ejecutando SweGraphic.loadSign()...')
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let vd=j.params.d
        let vm=j.params.m
        let va=j.params.a
        let vh=j.params.h
        let vmin=j.params.min
        let vgmt=j.params.gmt
        let vlon=j.params.lon
        let vlat=j.params.lat
        let d = new Date(Date.now())
        let ms=d.getTime()
         let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        let json=(\'\'+logData).replace(/\\n/g, \'\')\n'
        c+='        app.currentJsonSignData=JSON.parse(json)\n'
        c+='        PanelControlsSign.loadJson(app.currentJsonSignData)\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        console.log(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe_search_asc_aries.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodesign')
    }

}
