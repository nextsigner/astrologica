import QtQuick 2.12
//import QtGraphicalEffects 1.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.12
import Qt.labs.settings 1.1

import unik.UnikQProcess 1.0

import "Funcs.js" as JS
import "./comps" as Comps


AppWin {
    id: app
    visible: true
    visibility: "Maximized"
    color: 'black'
    title: 'Astrológica '+version
    property bool dev: false
    property string version: '1.0'
    property string mainLocation: ''
    property int fs: width*0.031
    property string url
    property string mod: 'mi'

    property bool enableAn: false
    property int msDesDuration: 500
    property var api: [panelNewVNA, panelFileLoader]



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
    property string currentLugar: ''
    property int currentAbsolutoGradoSolar: -1
    property int currentGradoSolar: -1
    property int currentMinutoSolar: -1
    property int currentSegundoSolar: -1
    property real currentGmt: 0
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
    property var meses: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre']
    property int uAscDegreeTotal: -1
    property int uAscDegree: -1
    property int uMcDegree: -1
    property string stringRes: "Res"+Screen.width+"x"+Screen.height

    property bool sspEnabled: false

    onCurrentPlanetIndexChanged: {
        if(sspEnabled){
            if(currentPlanetIndex>=-1&&currentPlanetIndex<10){
                app.ip.opacity=1.0
                app.ip.children[0].ssp.setPlanet(currentPlanetIndex)
            }else{
                app.ip.opacity=0.0
            }
        }
        panelDataBodies.currentIndex=currentPlanetIndex
        if(currentPlanetIndex>14){
            if(currentPlanetIndex===15){
                sweg.objHousesCircle.currentHouse=1
                swegz.sweg.objHousesCircle.currentHouse=1
            }
            if(currentPlanetIndex===16){
                sweg.objHousesCircle.currentHouse=10
                swegz.sweg.objHousesCircle.currentHouse=10
            }
        }
    }
    onCurrentGmtChanged: {
        if(app.currentData==='')return
        xDataBar.currentGmtText=''+currentGmt
        JS.setNewTimeJsonFileData(app.currentDate)
        JS.runJsonTemp()
    }
    onCurrentDateChanged: {
        if(app.currentData==='')return
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
        property bool showTimes: false
        property bool lt:false
    }
    Timer{
        id: tReload
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            //unik.speak('set file')
            JS.setNewTimeJsonFileData(app.currentDate)
            JS.runJsonTemp()
        }
    }
    Item{
        id: xApp
        anchors.fill: parent
        SweGraphic{id: sweg;objectName: 'sweg'}
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
    }
    Item{
        id: capa101
        anchors.fill: xApp
        XDataBar{
            id: xDataBar
        }
        Row{
            //anchors.centerIn: parent
            anchors.top: xDataBar.bottom
            anchors.bottom: xBottomBar.top
            Item{
                id: xLatIzq
                width: xApp.width*0.2
                height: parent.height
                Rectangle{anchors.fill: parent;color:'red';opacity: 0.5}
                SweGraphicZoom{id: swegz}
                PanelZonaMes{id: panelZonaMes}
                PanelRsList{id: panelRsList}
                PanelFileLoader{id: panelFileLoader}
                PanelNewVNA{id: panelNewVNA}
            }
            Item{
                id: xMed
                width: xApp.width-xLatIzq.width-xLatDer.width
                height: parent.height
            }
            Item{
                id: xLatDer
                width: xApp.width*0.2
                height: parent.height
                PanelControlsSign{id: panelControlsSign}
                PanelDataBodies{id: panelDataBodies}
                PanelPronEdit{id: panelPronEdit;}
            }
        }
        XLupa{id: xLupa}
        Comps.XLayerTouch{id: xLayerTouch}
        XTools{
            id: xTools
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }
        XBottomBar{id: xBottomBar}
        XSabianos{id: xSabianos}
    }
    Init{longAppName: 'Astrológica'; folderName: 'astrologica'}
    Component.onCompleted: {
        if(Qt.application.arguments.indexOf('-dev')>=0){
            app.dev=true
        }
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
