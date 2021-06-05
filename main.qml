import QtQuick 2.12
//import QtGraphicalEffects 1.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.12
import Qt.labs.settings 1.1

import unik.UnikQProcess 1.0

import "Funcs.js" as JS


AppWin {
    id: app
    visible: true
    visibility: "Maximized"
    color: 'black'
    title: 'Astrológica '+version
    property string version: '1.0'
    property string mainLocation: ''
    property int fs: width*0.031
    property string url
    property int mod: 0

    property string fileData: ''
    property string currentData: ''

    //Para analizar signos y ascendentes por región
    property int currentIndexSignData: 0
    property var currentJsonSignData: ''

    property int currentPlanetIndex: -1
    property int currentSignIndex: 0
    property date currentDate
    property string currentNom: ''
    property string currentFecha: ''
    property int currentGradoSolar: -1
    property int currentMinutoSolar: -1
    property int currentSegundoSolar: -1
    property int currentGmt: 0
    property real currentLon: 0.0
    property real currentLat: 0.0

    property bool lock: false
    property string uSon: ''

    property string uCuerpoAsp: ''

    property var signos: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var planetas: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Norte', 'N.Sur', 'Quirón', 'Selena', 'Lilith']
    property var planetasRes: ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 'n', 's', 'hiron', 'selena', 'lilith']
    property var objSignsNames: ['ari', 'tau', 'gem', 'cnc', 'leo', 'vir', 'lib', 'sco', 'sgr', 'cap', 'aqr', 'psc']
    property var signColors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    property int uAscDegree: -1
    property int uMcDegree: -1
    property string stringRes: "Res"+Screen.width+"x"+Screen.height

    onCurrentPlanetIndexChanged: {
        if(currentPlanetIndex>=0&&currentPlanetIndex<10){
            ssp.opacity=1.0
            ssp.setPlanet(currentPlanetIndex)
        }else{
            ssp.opacity=0.0
        }

        panelDataBodies.currentIndex=currentPlanetIndex        
    }
    onCurrentGmtChanged: {
        xDataBar.currentGmtText=''+currentGmt
        JS.setNewTimeJsonFileData(app.currentDate)
        JS.runJsonTemp()
    }
    onCurrentDateChanged: {
        xDataBar.state='show'
        let a=currentDate.getFullYear()
        let m=currentDate.getMonth()
        let d=currentDate.getDate()
        let h=currentDate.getHours()
        let min=currentDate.getMinutes()
        if(app.fileData!=='' && app.currentData!=='' ){
            JS.setNewTimeJsonFileData(currentDate)
        }
        xDataBar.currentDateText=d+'/'+parseInt(m + 1)+'/'+a+' '+h+':'+min
        xDataBar.currentGmtText=''+currentGmt
        JS.runJsonTemp()
    }

    Settings{
        id: apps
        fileName:'astrologica.cfg'
        property string url: ''
    }
    Item{
        id: xApp
        anchors.fill: parent
        SweGraphic{id: sweg}
        XDataBar{
            id: xDataBar
        }
        XTools{
            id: xTools
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }
        XStatus{id: xStatus}
        Grid{
            id: xAsp
            spacing: app.fs*0.1
            columns: 2
            anchors.bottom: parent.bottom
            function load(jsonData){
                for(var i=0;i<xAsp.children.length;i++){
                    xAsp.children[i].destroy(1)
                }
                if(!jsonData.asps)return
                let asp=jsonData.asps
                for(i=0;i<Object.keys(asp).length;i++){
                    if(asp['asp'+parseInt(i +1)]){
                        let a=asp['asp'+parseInt(i +1)]
                        //console.log('Asp: '+'asp'+parseInt(i +1))
                        let comp=Qt.createComponent('XAsp.qml')
                        let obj=comp.createObject(xAsp, {c1:a.c1, c2:a.c2, ic1:a.ic1, ic2:a.ic2, tipo:a.ia, indexAsp: i})
                    }
                }
            }
            function resaltar(c){
                for(var i=0;i<xAsp.children.length;i++){
                    xAsp.children[i].invertido=false
                }
                for(var i=0;i<xAsp.children.length;i++){
                    console.log('resaltar('+c+'); '+xAsp.children[i].c1)
                    let s1=xAsp.children[i].c1+'-'+xAsp.children[i].c2
                    let s2=xAsp.children[i].c2+'-'+xAsp.children[i].c1
                    if(s1.indexOf(app.uCuerpoAsp)>=0||s2.indexOf(app.uCuerpoAsp)>=0){
                        xAsp.children[i].opacity=1.0
                        xAsp.children[i].visible=true
                        if(xAsp.children[i].c1!==c){
                            xAsp.children[i].invertido=true
                        }
                        xAsp.columns=2
                    }else{
                        xAsp.columns=1
                        //if(xAsp.children[i].c1===c||xAsp.children[i].c2===c){
                        //                        if(xAsp.children[i].c2===c){
                        //                            xAsp.children[i].opacity=1.0
                        //                            xAsp.children[i].visible=true
                        //                            //xAsp.height=app.fs*2
                        //                        }else{
                        xAsp.children[i].opacity=0.5
                        xAsp.children[i].visible=false
                        //xAsp.height=app.fs*0.9
                        //}
                    }
                }
                if(c===app.uCuerpoAsp){
                    app.uCuerpoAsp=''
                }else{
                    app.uCuerpoAsp=c
                }
            }
        }
        Rectangle{
            id: xMsgProcDatos
            width: txtPD.contentWidth+app.fs
            height: app.fs*4
            color: 'black'
            border.width: 2
            border.color: 'white'
            visible: false
            anchors.centerIn: parent
            Text {
                id: txtPD
                text: 'Procesando datos...'
                font.pixelSize: app.fs
                color: 'white'
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: parent.visible=false
            }
        }
        XSabianos{id: xSabianos}
        PanelFileLoader{id: panelFileLoader}
        PanelDataBodies{id: panelDataBodies}
        PanelControlsSign{id: panelControlsSign}
        PanelNewVNA{id: panelNewVNA}
    }
    Init{longAppName: 'Astrológica'; folderName: 'astrologica'}
    Component.onCompleted: {
        JS.setFs()
        app.mainLocation=unik.getPath(1)
        console.log('app.mainLocation: '+app.mainLocation)
        console.log('Init app.url: '+app.url)
        if(apps.url!==''){
            console.log('Cargando al iniciar: '+apps.url)
            JS.loadJson(apps.url)
        }
    }
}
