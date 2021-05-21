import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.12
import Qt.labs.settings 1.1

import QtMultimedia 5.12

import unik.UnikQProcess 1.0

ApplicationWindow {
    id: app
    visible: true
    visibility: "Maximized"
    color: 'black'
    title: 'Astrológica '+version
    property string version: '1.0'
    property int fs: width*0.03
    property string url
    property int mod: 0

    property string fileData: ''
    property string currentData: ''

    property int currentPlanetIndex: 0
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
    property int uAscDegree: -1
    property int uMcDegree: -1
    property string stringRes: "Res"+Screen.width+"x"+Screen.height

    onCurrentPlanetIndexChanged: {
        panelDataBodies.currentIndex=currentPlanetIndex
    }
    onCurrentGmtChanged: {
        xDataBar.currentGmtText=''+currentGmt
        setNewTimeJsonFileData(app.currentDate)
        runJsonTemp()
    }
    onCurrentDateChanged: {
        xDataBar.state='show'
        let a=currentDate.getFullYear()
        let m=currentDate.getMonth()
        let d=currentDate.getDate()
        let h=currentDate.getHours()
        let min=currentDate.getMinutes()

        if(app.fileData!=='' && app.currentData!=='' ){
            setNewTimeJsonFileData(currentDate)
        }
        xDataBar.currentDateText=d+'/'+m+'/'+a+' '+h+':'+min
        xDataBar.currentGmtText=''+currentGmt
        runJsonTemp()
    }

    MediaPlayer{
        id: mp
        source:'/home/ns/nsp/uda/twitch-speech/sounds/beep.wav'
        autoLoad: true
        autoPlay: true
        volume: 0.2
    }
    Settings{
        id: apps
        property string url: ''
    }
    Item{
        id: xApp
        anchors.fill: parent
        SweGraphic{
            id: sweg
            width: parent.height*0.8
            height: width
            anchors.centerIn: parent
        }
        XDataBar{
            id: xDataBar
        }
        XTools{
            id: xTools
            anchors.bottom: parent.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
        }
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
                        console.log('Asp: '+'asp'+parseInt(i +1))
                        let comp=Qt.createComponent('XAsp.qml')
                        let obj=comp.createObject(xAsp, {c1:a.c1, c2:a.c2, ic1:a.ic1, ic2:a.ic2, tipo:a.ia})                        
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
    }
    Shortcut{
        sequence: 'Ctrl+Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.ctrlDown()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.ctrlUp()
                return
            }
            if(app.mod===0){
                app.mod=1
            }else{
                app.mod=0
                xFlecha.x=0-app.fs*3
                xFlecha.y=0-app.fs*3
            }
        }
    }
    Shortcut{
        sequence: 'Space'
        onActivated: app.lock=!app.lock
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.visible=false
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.up()
                return
            }
            if(currentPlanetIndex>0){
                currentPlanetIndex--
            }else{
                currentPlanetIndex=14
            }
            //xAreaInteractiva.back()
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.down()
                return
            }
            if(currentPlanetIndex<14){
                currentPlanetIndex++
            }else{
                currentPlanetIndex=0
            }
            //xAreaInteractiva.next()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.left()
                return
            }
            xAreaInteractiva.acercarAlCentro()
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.right()
                return
            }
            xAreaInteractiva.acercarAlBorde()
        }
    }

    Shortcut{
        sequence: 'Ctrl+f'
        onActivated: {
            panelFileLoader.state=panelFileLoader.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+i'
        onActivated: {
            panelDataBodies.state=panelDataBodies.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+e'
        onActivated: {
            sweg.expand=!sweg.expand
        }
    }
    Shortcut{
        sequence: 'Ctrl+n'
        onActivated: {
            xFormZS.visible=!xFormZS.visible
        }
    }
    Shortcut{
        sequence: 'Ctrl+r'
        onActivated: {
            if(!xFormRS.visible){
                xFormRS.alNom=app.currentNom
                xFormRS.alFecha=app.currentFecha
                xFormRS.grado=app.currentGradoSolar
                Qt.ShiftModifierxFormRS.minuto=app.currentMinutoSolar
                xFormRS.segundo=app.currentSegundoSolar
                xFormRS.lon=app.currentLon
                xFormRS.lat=app.currentLat
            }
            xFormRS.visible=!xFormZS.visible
        }
    }
    Shortcut{
        sequence: 'Ctrl+o'
        onActivated: {
            //img.y+=4
            showIWFILES()
        }
    }
    Shortcut{
        sequence: 'Ctrl+s'
        onActivated: {
            //img.y+=4
            showSABIANOS()
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.zoomDown()
                return
            }
            signCircle.subir()
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.zoomUp()
                return
            }
            signCircle.bajar()
        }
    }


    Init{longAppName: 'Astrológica'; folderName: 'astrologica'}
    Component.onCompleted: {
        if(apps.url!==''){
            console.log('Cargando al iniciar: '+apps.url)
            loadJson(apps.url)
        }
    }
    function showIW(){
        console.log('uSon: '+app.uSon)
        let m0=app.uSon.split('_')
        let fileLocation='./iw/main.qml'
        let comp=Qt.createComponent(fileLocation)

        //Cuerpo en Casa
        let nomCuerpo=m0[0]!=='asc'?app.planetas[app.planetasRes.indexOf(m0[0])]:'Ascendente'
        let jsonFileName=m0[0]!=='asc'?quitarAcentos(nomCuerpo.toLowerCase())+'.json':'asc.json'
        let jsonFileLocation='/home/ns/nsp/uda/quiron/data/'+jsonFileName
        if(!unik.fileExist(jsonFileLocation)){
            let obj=comp.createObject(app, {textData:'No hay datos disponibles.', width: app.fs*8, height: app.fs*3, fs: app.fs*0.5, title:'SinQt.ShiftModifier datos'})
        }else{
            let numHome=m0[0]!=='asc'?-1:1
            let vNumRom=['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII']
            numHome=vNumRom.indexOf(m0[2])+1
            //console.log('::::Abriendo signo: '+app.objSignsNames.indexOf(m0[1])+' casa: '+numHome+' nomCuerpo: '+nomCuerpo)
            getJSON(jsonFileName, comp, app.objSignsNames.indexOf(m0[1])+1, numHome, nomCuerpo)
        }
    }
    function showIWFILES(){
        console.log('uSon: '+app.uSon)
        let m0=app.uSon.split('_')
        let fileLocation='./iwfiles/main.qml'
        let comp=Qt.createComponent(fileLocation)
        let obj=comp.createObject(app, {comp: app, width: app.fs*14, fs: app.fs*0.5, title:'Cargar Archivos'})
    }
    function showSABIANOS(numSign, numDegree){
        xSabianos.numSign=numSign
        xSabianos.numDegree=numDegree
        xSabianos.visible=true
        xSabianos.loadData()
        /*console.log('uSon: '+app.uSon)
        let m0=app.uSon.split('_')
        let fileLocation='./sabianos/main.qml'
        let comp=Qt.createComponent(fileLocation)
        let obj=comp.createObject(app, {comp: app, width: app.fs*14, fs: app.fs*0.5, htmlFolder: './sabianos/', numSign: numSign, numDegree:numDegree})*/
    }
    function getJSON(fileLocation, comp, s, c, nomCuerpo) {
        var request = new XMLHttpRequest()

        //Url GitHub Raw Data
        //https://github.com/nextsigner/quiron/raw/main/data/pluton.json

        //Url File Local Data
        //'file:///home/ns/Documentos/unik/quiron/data/neptuno.json'

        let jsonFileUrl='file:///home/ns/nsp/uda/quiron/data/'+fileLocation
        //console.log('jsonFileUrl: '+jsonFileUrl)
        request.open('GET', jsonFileUrl, true);
        //request.open('GET', 'https://github.com/nextsigner/quiron/raw/main/data/'+cbPlanetas.currentText+'.json', true);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    //console.log(":::", request.responseText)
                    var result = JSON.parse(request.responseText)
                    if(result){
                        //console.log(result)
                        //console.log('Abriendo casa de json: '+c)
                        console.log('Abriendo dato signo:'+s+' casa:'+c+'...')
                        let dataJson0=''
                        let data=''//+result['h'+c]
                        if(result['h'+c]){
                            console.log('Abriendo dato de casa... ')
                            dataJson0=result['h'+c].split('|')
                            data='<h2>'+nomCuerpo+' en casa '+c+'</h2>'
                            for(var i=0;i<dataJson0.length;i++){
                                data+='<p>'+dataJson0[i]+'</p>'
                            }
                        }
                        //console.log('Signo para mostar: '+s)
                        if(result['s'+s]){
                            console.log('Abriendo dato de signo... ')
                            dataJson0=result['s'+s].split('|')
                            data+='<h2>'+nomCuerpo+' en '+app.signos[s - 1]+'</h2>'
                            for(i=0;i<dataJson0.length;i++){
                                data+='<p>'+dataJson0[i]+'</p>'
                            }
                        }
                        let obj=comp.createObject(app, {textData:data, width: app.fs*14, fs: app.fs*0.5, title: nomCuerpo+' en '+app.signos[s - 1]+' en casa '+c, xOffSet: app.fs*6})
                    }
                    //console.log('Data-->'+JSON.stringify(result))
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }
        }
        request.send()
    }

    function quitarAcentos(cadena){
        const acentos = {'á':'a','é':'e','í':'i','ó':'o','ú':'u','Á':'A','É':'E','Í':'I','Ó':'O','Ú':'U'};
        return cadena.split('').map( letra => acentos[letra] || letra).join('').toString();
    }
    function setInfo(i1, i2, i3, son){
        if(son){
            infoCentral.info1=i1
            infoCentral.info2=i2
            infoCentral.info3=i3
            app.uSon=son
        }
    }
    function getEdad(d, m, a, h, min) {
        let hoy = new Date()
        let fechaNacimiento = new Date(a, m, d, h, min)
        let edad = hoy.getFullYear() - fechaNacimiento.getFullYear()
        let diferenciaMeses = hoy.getMonth() - fechaNacimiento.getMonth()
        if (
                diferenciaMeses < 0 ||
                (diferenciaMeses === 0 && hoy.getDate() < fechaNacimiento.getDate())
                ) {
            edad--
        }
        return edad
    }
    function runCmd(){
        let c='import unik.UnikQProcess 1.0\n'
            +'UnikQProcess{\n'
            +'  '
            +'}\n'
    }

    //Astrologica
    function loadJson(file){
        apps.url=file
        let fn=apps.url
        let jsonFileName=fn
        let jsonFileData=unik.getFile(jsonFileName).replace(/\n/g, '')
        //console.log(jsonFileData)

        app.fileData=jsonFileData
        app.currentData=app.fileData
        let jsonData=JSON.parse(jsonFileData)

        let nom=jsonData.params.n.replace(/_/g, ' ')
        let vd=jsonData.params.d
        let vm=jsonData.params.m
        let va=jsonData.params.a
        let vh=jsonData.params.h
        let vmin=jsonData.params.min
        let vgmt=jsonData.params.gmt
        let vlon=jsonData.params.lon
        let vlat=jsonData.params.lat
        let vCiudad=jsonData.params.ciudad.replace(/_/g, ' ')
        let edad=''
        let numEdad=getEdad(parseInt(va), parseInt(vm), parseInt(vd), parseInt(vh), parseInt(vmin))
        let stringEdad=edad.indexOf('NaN')<0?edad:''
        let textData=''
        if(parseInt(numEdad)>0){
            edad=' <b>Edad:</b> '+numEdad
            textData=''
                    +'<b>'+nom+'</b> '
                    +''+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs GMT '+vgmt+stringEdad+' '
                    +'<b> '+vCiudad+'</b> '
                    +'<b>long:</b> '+vlon+' <b>lat:</b> '+vlat+' '
        }else{
            textData=''
                    +'<b>Revolución Solar</b></p> '
                    +'<b>'+nom+'</b> '
                    +'<b>Cumpleaños Astrológico: </b>'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs '
            //+'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
            //+'<p style="font-size:20px;"> <b>long:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'

        }

        //Seteando datos globales de mapa energético
        app.currentDate= new Date(parseInt(va), parseInt(vm), parseInt(vd), parseInt(vh), parseInt(vmin))

        //getCmdData.getData(vd, vm, va, vh, vmin, vlon, vlat, 0, vgmt)
        app.currentNom=nom
        app.currentFecha=vd+'/'+vm+'/'+va
        app.currentGmt=vgmt
        app.currentLon=vlon
        app.currentLat=vlat

        xDataBar.fileData=textData
        xDataBar.state='show'
        sweg.load(jsonData)
        //xAsp.load(jsonData)
    }
    function runJsonTemp(){
        let jsonData=JSON.parse(app.currentData)
        let nom=jsonData.params.n.replace(/_/g, ' ')
        let vd=jsonData.params.d
        let vm=jsonData.params.m
        let va=jsonData.params.a
        let vh=jsonData.params.h
        let vmin=jsonData.params.min
        let vgmt=app.currentGmt
        let vlon=jsonData.params.lon
        let vlat=jsonData.params.lat
        let vCiudad=jsonData.params.ciudad.replace(/_/g, ' ')
        let edad=''
        let numEdad=getEdad(parseInt(va), parseInt(vm), parseInt(vd), parseInt(vh), parseInt(vmin))
        let stringEdad=edad.indexOf('NaN')<0?edad:''
        let textData=''
        app.currentFecha=vd+'/'+vm+'/'+va
        //xDataBar.state='show'
        sweg.load(jsonData)
        xAsp.load(jsonData)
    }
    function setNewTimeJsonFileData(date){
        let jsonData=JSON.parse(app.fileData)
        console.log('json: '+JSON.stringify(jsonData))
        console.log('json2: '+jsonData.params)
        let d = new Date(Date.now())
        let ms=jsonData.params.ms
        let nom=jsonData.params.n.replace(/_/g, ' ')

        let vd=date.getDate()
        let vm=date.getMonth()
        let va=date.getFullYear()
        let vh=date.getHours()
        let vmin=date.getMinutes()

        let vgmt=app.currentGmt
        let vlon=jsonData.params.lon
        let vlat=jsonData.params.lat
        let vCiudad=jsonData.params.ciudad.replace(/_/g, ' ')
        let j='{'
        j+='"params":{'
        j+='"ms":'+ms+','
        j+='"n":"'+nom+'",'
        j+='"d":'+vd+','
        j+='"m":'+vm+','
        j+='"a":'+va+','
        j+='"h":'+vh+','
        j+='"min":'+vmin+','
        j+='"gmt":'+vgmt+','
        j+='"lat":'+vlat+','
        j+='"lon":'+vlon+','
        j+='"ciudad":"'+vCiudad+'"'
        j+='}'
        j+='}'
        app.currentData=j
        //console.log('j: '+j)
        //console.log('fd: '+app.fileData)
    }
    function saveJson(){
        app.fileData=app.currentData
        let jsonFileName=apps.url
        unik.setFile(jsonFileName, app.currentData)
    }
}
