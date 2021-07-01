import QtQuick 2.7
import QtQuick.Controls 2.0
import "Funcs.js" as JS

Rectangle {
    id: r
    width: parent.width*0.3
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    property alias currentIndex: lv.currentIndex
    property alias listModel: lm
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
    Behavior on x{NumberAnimation{duration: 250}}
    onStateChanged: {
        if(state==='hide')txtLabelTit.focus=false
        xApp.focus=true
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
                text: 'Revoluciones Solares'
                font.pixelSize: app.fs*0.5
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                color: 'white'
                focus: true
                anchors.centerIn: parent
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
        }
    }


    ListModel{
        id: lm
        function addItem(vRsDate, vData){
            return {
                rsDate: vRsDate,
                dato: vData,
                indexSign:-1
            }
        }
    }
    Component{
        id: compItemList
        Rectangle{
            id: itemRS
            width: lv.width
            height: txtData.contentHeight+app.fs
            color: 'black'//index===lv.currentIndex?'white':'black'
            border.width: index===lv.currentIndex?4:2
            border.color: 'white'
            property int is: indexSign
            onIsChanged: {
                let c='white'
                if(is===0||is===4||is===8){
                    c=app.signColors[0]
                }
                if(is===1||is===5||is===9){
                    c=app.signColors[1]
                }
                if(is===2||is===6||is===10){
                    c=app.signColors[2]
                }
                if(is===3||is===7||is===11){
                    c=app.signColors[3]
                }
                color=c
            }

            Row{
                id: row
                anchors.centerIn: parent
                spacing: app.fs*0.5
                Rectangle{
                    id: labelEdad
                    width: txtEdad.contentWidth+app.fs*0.25
                    height: txtEdad.contentHeight+app.fs*0.25
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: app.fs*0.1
                    Text {
                        id: txtEdad
                        text: '<b>'+parseInt(index)+'</b>'
                        color: 'white'
                        font.pixelSize: app.fs*0.5
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            getAsc(index, rsDate, itemRS)
                        }
                    }
                }
                Rectangle{
                    id: labelFecha
                    width: txtData.contentWidth+app.fs*0.25
                    height: txtData.contentHeight+app.fs*0.25
                    color: 'black'
                    border.width: 1
                    border.color: 'white'
                    radius: app.fs*0.1
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: txtData
                        text: dato
                        font.pixelSize: app.fs*0.5
                        width: itemRS.width-app.fs-iconoSigno.width-row.spacing*2-labelEdad.width//indexSign===-1?itemRS.width-app.fs:itemRS.width-app.fs-iconoSigno.width-row.spacing
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        color: index===lv.currentIndex?'black':'white'
                        anchors.centerIn: parent
                    }
                }
                Rectangle{
                    width: app.fs
                    height: width
                    border.width: 2
                    radius: width*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: iconoSigno
                        source: indexSign!==-1?"./resources/imgs/signos/"+indexSign+".svg":""
                        width: parent.width*0.8
                        height: width
                        anchors.centerIn: parent
                    }
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: lv.currentIndex=index
                onDoubleClicked: {
                    //JS.loadJson(fileName)
                    //r.state='hide'
                }
            }

            Timer{
                running: true
                repeat: false
                interval: 500*(index+1)
                onTriggered: {
                    if(index===0){
                        getAsc(index, rsDate, itemRS)
                    }
                   /* if(parent.color==='white'){
                        parent.color='red'
                    }

                    let cd=rsDate
                    cd = cd.setFullYear(rsDate.getFullYear())
                    let cd2=new Date(cd)
                    cd2 = cd2.setDate(cd2.getDate() - 1)
                    let cd3=new Date(cd2)
                    let finalCmd=''
                        +'python3 ./py/astrologica_swe_search_revsol.py '+cd3.getDate()+' '+parseInt(cd3.getMonth() +1)+' '+cd3.getFullYear()+' '+cd3.getHours()+' '+cd3.getMinutes()+' '+app.currentGmt+' '+app.currentLat+' '+app.currentLon+' '+app.currentGradoSolar+' '+app.currentMinutoSolar+' '+app.currentSegundoSolar+''
                    //console.log('finalCmd: '+finalCmd)
                    let c=''
                    c+=''
                            +'  let s=""+logData\n'
                            +'  console.log("RSList: "+s)\n'
                            +'  let j=JSON.parse(s)\n'
                            +'  let o=j.params\n'
                            +'  let m0=o.sd.split(" ")\n'
                            +'  let m1=m0[0].split("/")\n'
                            +'  let m2=m0[1].split(":")\n'
                            +'  lm.get('+index+').dato=""+o.sd\n'
                            +'  o=j.ph\n'
                            +'  lm.get('+index+').indexSign=o.h1.is\n'

                    mkCmd(finalCmd, c, itemRS)*/
                }
            }
        }
    }
    Item{id: xuqp}
    Timer{
        id: tSearchAsc
        running: false
        repeat: false
        interval: 100
        property int index
        property var rsDate
        property var itemRS
        onTriggered: {
            getAsc(index, rsDate, itemRS)
        }
    }

    Component.objectName: {
        //r.state='show'
        //setRsList(150)
    }
    function setRsList(edad){
        lm.clear()
        r.state='show'
        let arraDates =[]
        for(var i=0;i<edad;i++){
            let d = app.currentDate
            d = d.setFullYear(d.getFullYear() + i)
            let d2= new Date(d)
            console.log('d: '+d2.toString())
            arraDates.push(d2)
        }
        for(i=0;i<arraDates.length;i++){
            lm.append(lm.addItem(arraDates[i], arraDates[i].toString()))
        }
    }
    function mkCmd(finalCmd, code, item){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='import "Funcs.js" as JS\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        '+code+'\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        run(\''+finalCmd+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, item, 'uqpcodecmd')
    }
    function getAsc(index, rsDate,itemRS){
        //let aaa=lv.
        let cd=rsDate
        cd = cd.setFullYear(rsDate.getFullYear())
        let cd2=new Date(cd)
        cd2 = cd2.setDate(cd2.getDate() - 1)
        let cd3=new Date(cd2)
        let finalCmd=''
            +'python3 ./py/astrologica_swe_search_revsol.py '+cd3.getDate()+' '+parseInt(cd3.getMonth() +1)+' '+cd3.getFullYear()+' '+cd3.getHours()+' '+cd3.getMinutes()+' '+app.currentGmt+' '+app.currentLat+' '+app.currentLon+' '+app.currentGradoSolar+' '+app.currentMinutoSolar+' '+app.currentSegundoSolar+''
        //console.log('finalCmd: '+finalCmd)
        let c=''
        c+=''
                +'  let s=""+logData\n'
                +'  console.log("RSList: "+s)\n'
                +'  let j=JSON.parse(s)\n'
                +'  let o=j.params\n'
                +'  let m0=o.sd.split(" ")\n'
                +'  let m1=m0[0].split("/")\n'
                +'  let m2=m0[1].split(":")\n'
                +'  lm.get('+index+').dato=""+o.sd\n'
                +'  o=j.ph\n'
                +'  lm.get('+index+').indexSign=o.h1.is\n'
                +'  lv.currentIndex='+parseInt(index )+'\n'
                +'  tSearchAsc.index='+parseInt(index + 1)+'\n'
                +'  tSearchAsc.rsDate=lm.get('+parseInt(index + 1)+').rsDate\n'
                +'  tSearchAsc.itemRS=lv.itemAtIndex('+parseInt(index + 1)+')\n'
                +'  tSearchAsc.start()\n'
                //+'  getAsc('+parseInt(index + 1)+', lm.get('+parseInt(index + 1)+').rsDate, lv.itemAtIndex('+parseInt(index + 1)+')) \n'

        mkCmd(finalCmd, c, itemRS)
    }
}
