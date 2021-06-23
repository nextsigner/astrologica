import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12

Rectangle {
    id: r
    width: parent.width*0.25
    height: xDataBar.state==='hide'?parent.height:parent.height-xDataBar.height
    anchors.bottom: parent.bottom
    color: 'black'
    //border.width: 2
    //border.color: 'white'
    state: 'hide'
    property alias currentIndex: lv.currentIndex
    property int currentIndexSign: -1
    Behavior on height{NumberAnimation{duration:350;easing.type: Easing.InOutQuad}}
    onCurrentIndexChanged: {
        if(!r.enabled)return
        sweg.objHousesCircle.currentHouse=currentIndex
        swegz.sweg.objHousesCircle.currentHouse=currentIndex
    }
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
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
        }
    }
    Rectangle{
        width: 1
        height: parent.height
    }
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: app.fs*0.25
        Rectangle{
            width: lv.width
            height: app.fs
            color: 'black'
            border.width: 2
            border.color: 'white'
            Text {
                text: '<b>Astrológica v1.0 by @nextsigner</b>'
                font.pixelSize: app.fs*0.5
                width: contentWidth
                color: 'white'
                anchors.centerIn: parent
            }
        }
        ListView{
            id: lv
            width: r.width-r.border.width*2
            height: r.height
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: compItemList
            model: lm
            //currentIndex: app.currentPlanetIndex
            clip: true
            onCurrentIndexChanged: {
                //console.log('panelbodies currentIndex: '+currentIndex)
                //let item=lm.get(currentIndex)
                //app.uSon='_'+app.objSignsNames[item.is]+'_1'
                if(!r.enabled)return
                //r.currentIndexSign=lm.get(currentIndex).is
            }
        }
    }


    ListModel{
        id: lm
        function addItem(indexSign, indexHouse, grado, minuto, segundo, stringData){
            return {
                is: indexSign,
                ih: indexHouse,
                gdeg:grado,
                mdeg: minuto,
                sdeg: segundo,
                sd: stringData
            }
        }
    }
    Component{
        id: compItemList
        Rectangle{
            width: lv.width
            height: txtData.contentHeight+app.fs*0.1
            color: index===app.currentPlanetIndex?'white':'black'
            border.width: index===app.currentPlanetIndex?2:0
            border.color: 'white'
            Text {
                id: txtData
                text: sd
                font.pixelSize: app.fs*0.45
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                color: index===app.currentPlanetIndex?'black':'white'
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    app.currentPlanetIndex=index
                }
                Rectangle{
                    anchors.fill: parent
                    color: 'red'
                    visible: false
                }
            }
        }
    }
    function loadJson(json){
        lm.clear()
        let jo
        let o
        for(var i=0;i<15;i++){
            jo=json.pc['c'+i]
            var s = jo.nom+ ' °' +jo.rsgdeg+ '\'' +jo.mdeg+ '\'\'' +jo.sdeg+ ' ' +app.signos[jo.is]+ '  - Casa ' +jo.ih
            //console.log('--->'+s)
            lm.append(lm.addItem(jo.is, jo.ih, jo.rsgdeg, jo.mdeg, jo.sdeg, s))
        }
        let o1=json.ph['h1']
        s = 'Ascendente °' +o1.rsgdeg+ '\'' +o1.mdeg+ '\'\'' +o1.sdeg+ ' ' +app.signos[o1.is]
        lm.append(lm.addItem(o1.is, 1, o1.rsgdeg, o1.mdeg, o1.sdeg,  s))
        o1=json.ph['h10']
        s = 'Medio Cielo °' +o1.rsgdeg+ '\'' +o1.mdeg+ '\'\'' +o1.sdeg+ ' ' +app.signos[o1.is]
        lm.append(lm.addItem(o1.is, 10, o1.rsgdeg, o1.mdeg, o1.sdeg, s))
        if(app.mod!==0)r.state='show'
    }
}
