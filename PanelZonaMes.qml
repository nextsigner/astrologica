import QtQuick 2.7
import QtQuick.Controls 2.0
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
    property int currentYear: -1
    property int currentMonth: -1
    property int currentDate: -1
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
                text: 'Revoluciones Solares hasta los '+r.edadMaxima+' años'
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
            id: itemRS
            width: lv.width-r.border.width*2
            height: txtData.contentHeight+app.fs//index!==lv.currentIndex?app.fs*1.5:app.fs*3.5//txtData.contentHeight+app.fs*0.1
            color: 'black'//index===lv.currentIndex?'white':'black'
            property int is: -1
            property var rsDate
            anchors.horizontalCenter: parent.horizontalCenter
            //opacity: is!==-1?1.0:0.0
            onIsChanged:{
                iconoSigno.source="./resources/imgs/signos/"+is+".svg"
            }
            Behavior on height{NumberAnimation{duration: app.msDesDuration}}
            Behavior on opacity{NumberAnimation{duration: app.msDesDuration}}
            Rectangle{
                id: bg
                width: parent.width
                height: itemRS.height//app.fs*1.5
                anchors.centerIn: parent
                color: app.signColors[itemRS.is]
            }
            Column{
                anchors.centerIn: parent
                Row{
                    id: row
                    spacing: app.fs*0.1
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle{
                        id: labelFecha
                        //width: txtData.contentWidth+app.fs*0.25
                        width: itemRS.width-app.fs*0.5-iconoSigno.width-row.spacing*2
                        height: txtData.contentHeight+app.fs*0.25
                        color: 'black'
                        border.width: 1
                        border.color: 'white'
                        radius: app.fs*0.1
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            id: txtData
                            //text: (itemRS.is!==-1?'<b>Ascendente '+app.signos[itemRS.is]+'</b><br />':'')+dato
                            font.pixelSize: app.fs*0.35
                            width: parent.width
                            wrapMode: Text.WordWrap
                            textFormat: Text.RichText
                            horizontalAlignment: Text.AlignHCenter
                            color: 'white'//index===lv.currentIndex?'black':'white'
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle{
                        width: index===lv.currentIndex?bg.height*0.45:bg.height*0.45
                        height: width
                        border.width: 2
                        radius: width*0.5
                        anchors.verticalCenter: parent.verticalCenter
                        Image {
                            id: iconoSigno
                            //source: indexSign!==-1?"./resources/imgs/signos/"+indexSign+".svg":""
                            width: parent.width*0.8
                            height: width
                            anchors.centerIn: parent
                        }
                    }
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    lv.currentIndex=index
                    //r.state='hide'
                    // xBottomBar.objPanelCmd.makeRS(itemRS.rsDate)
                }
            }
            Component.onCompleted: {
                console.log('index '+index+': '+JSON.stringify(json))
                let fs1=parseInt(app.fs*0.75)
                let fs2=parseInt(fs1*0.6)
                let data='<b style="font-size:'+fs1+'px;">'+json['nom']+'</b><br/>'
                +'<b style="font-size:'+fs2+'px;">'+json['des']+'</b>'
                txtData.text=data
            }
        }
    }
    Item{id: xuqp}
    Component.onCompleted: {
        loadZonas()
    }
    function loadZonas(){
        let fileName='./jsons/hm/zonas.json'
        let fileData=unik.getFile(fileName)
        console.log('json zonas: '+fileData)
        let j=JSON.parse(fileData)
        for(var i=0;i<Object.keys(j.zonas).length;i++){
            lm.append(lm.addItem(j['zonas']['z'+parseInt(i+1)]))
        }
    }
}
