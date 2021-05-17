import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.12
import Qt.labs.settings 1.1

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

    property date currentDate
    property string currentNom: ''
    property string currentFecha: ''
    property int currentGradoSolar: -1
    property int currentMinutoSolar: -1
    property int currentSegundoSolar: -1
    property real currentLon: 0.0
    property real currentLat: 0.0

    property bool lock: false
    property string uSon: ''

    property string uCuerpoAsp: ''

    property var signos: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var planetas: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'Quirón', 'Proserpina', 'Selena', 'Lilith', 'N.Sur', 'N.Norte']
    property var planetasRes: ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 'hiron', 'proserpina', 'selena', 'lilith', 's', 'n']
    property var objSignsNames: ['ari', 'tau', 'gem', 'cnc', 'leo', 'vir', 'lib', 'sco', 'sgr', 'cap', 'aqr', 'psc']
    property int uAscDegree: -1
    property int uMcDegree: -1
    property string stringRes: "Res"+Screen.width+"x"+Screen.height

    onCurrentDateChanged: {
        let a=currentDate.getFullYear()
        let m=currentDate.getMonth()+1
        let d=currentDate.getDate()
        let h=currentDate.getHours()
        let min=currentDate.getMinutes()
        xState.currentDateString=d+'/'+m+'/'+a+' '+h+':'+min
    }

    Settings{
        id: apps
        property string url: ''
    }
    FolderListModel{
        folder: 'file:///home/ns/temp-screenshots'
        showDirs: false
        showFiles: true
        showHidden: false
        nameFilters: [ "*.png" ]
        sortReversed: true
        sortField: FolderListModel.Time
        onCountChanged: {
            //console.log(get(count-1, 'fileName'))
            //app.url='/home/ns/temp-screenshots/'+get(count-1, 'fileName')
            //load(app.url)
        }
    }
    Timer{
        id: tLoadData
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            xAreaInteractiva.loadData()
            xAreaInteractivaZoom.loadData()
        }
    }
    Timer{
        id: tUpdate
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            let d=new Date(Date.now())
            img.source=apps.url+'?r='+d.getTime()
            img2.source=apps.url+'?r='+d.getTime()
            //img2.x=600//img2.parent.width*4
            //img2.y=img2.parent.height*4
        }
    }
    Timer{
        id: tReload
        running: false
        repeat: false
        interval: 3000
        onTriggered: {
            let d=new Date(Date.now())
            img.source=apps.url+'?r='+d.getTime()
            img2.source=apps.url+'?r='+d.getTime()
            img2.x=0-app.fs*10.5
            img2.y=0-img2.parent.height*0.5-app.fs*2.25
            xMira.visible=true
        }
    }

    Item{
        id: xApp
        anchors.fill: parent
        Rectangle{
            id: xImg
            width: parent.width
            height: parent.height
            //border.width: 8
            border.color: app.mod===0?'red':'yellow'
            color: 'black'
            Image{
                id: img
                source: apps.url
                width: xApp.width
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: xApp.width*0.25
                visible: false
                property bool mov: false
                onStatusChanged: {
                    //Image.Error
                    if(status===Image.Error){
                        tReload.start()
                    }
                    if(status===Image.Ready){
                        //Qt.quit()
                        //img2.x=0-600
                        //img2.y=Screen.height*0.5+500//0-img2.height*2+xMira.height
                    }
                }
                onXChanged:{
                    mov=true
                    trm.restart()
                }
                onYChanged:{
                    mov=true
                    trm.restart()
                }
                Timer{
                    id: trm
                    running: false
                    repeat: false
                    interval: 100
                    onTriggered: {
                        img.mov=false
                    }
                }
                Behavior on x{
                    NumberAnimation{duration:750;easing.type: Easing.InOutCubic}
                }
                Behavior on y{
                    NumberAnimation{duration:750;easing.type: Easing.InOutCubic}
                }

            }
            MouseArea{
                anchors.fill: img
                //drag.target: parent
                //drag.axis: Drag.XAndYAxis
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    info.text=mouseX
                    img2.x=0-mouseX*2+img2.parent.width*0.5
                    img2.y=0-mouseY*2+img2.parent.height*0.5

                    //xMiraDer.x=mouseX+img.anchors.horizontalCenterOffset-xMiraDer.width*0.5
                    //xMiraDer.y=mouseY-xMiraDer.height*0.5+img.y//app.fs*2

                }
            }
            FastBlur {
                id: fb
                anchors.fill: img
                source: img
                radius: 2
                visible: false
            }
            BrightnessContrast {
                id: bc
                anchors.fill: fb
                source: fb
                brightness: 0.35
                contrast: 0.7
            }
            XAreaInteractiva{
                id: xAreaInteractiva
                anchors.fill: img
                onSeteandoObj: xAreaInteractivaZoom.setShow(objName, set)
            }
            XMira{
                id: xMiraDer
                w:app.fs*1.5
                mov: false//enabled?img.mov:true
                property bool enabled: true
                visible: false
            }
            Rectangle{
                id: infoCentral
                width: app.fs*7.24
                height: width
                radius: width*0.5
                color: colInfo.visible?'white':'transparent'
                border.width: colInfo.visible?4:0
                border.color: 'red'
                clip: true
                anchors.centerIn: img
                anchors.horizontalCenterOffset: app.fs*0.8
                //rotation: 0-parent.rotation
                property bool show: false
                property string info1: ''
                property string info2: ''
                property string info3: ''
                opacity: info1+info2+info3!==''//show?1.0:0.0
                Behavior on opacity {
                    NumberAnimation{duration: 200}
                }
                Column{
                    id: colInfo
                    spacing: app.fs*0.1
                    anchors.centerIn: parent
                    Text {
                        id: i1
                        color: 'red'
                        font.pixelSize: app.fs*1.5
                        text: infoCentral.info1
                        width:  parent.width-app.fs
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: i2
                        color: 'red'
                        font.pixelSize: app.fs*2
                        text: infoCentral.info2
                        width:  parent.width-app.fs*1.5
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: i3
                        color: 'red'
                        font.pixelSize: app.fs*2
                        text: infoCentral.info3
                        width:  parent.width-app.fs
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Behavior on opacity{NumberAnimation{duration: 250}}
                Repeater{
                    model: 18
                    Rectangle{
                        width: infoCentral.width
                        height: app.fs
                        color: 'transparent'
                        anchors.centerIn: parent
                        rotation: index*10
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(!colInfo.visible){
                                    colInfo.visible=true
                                }else{
                                    colInfo.visible=false
                                }
                            }
                        }
                    }
                }

            }
            SweGraphic{
                id: sweg
                width: parent.width*10
                height: width
                anchors.centerIn: infoCentral

            }
        }

        //        XCentralCircle{
        //            id: xCentralCircle
        //            opacity: 0.3
        //        }
        Item{
            id: xAreaFlecha
            anchors.fill: parent
            visible: app.mod===1
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    xFlecha.x=mouseX
                    xFlecha.y=mouseY
                }
            }
        }
        Item{
            id: xImg2
            width: parent.width*0.5
            height: parent.height
            clip: true
            Image{
                id: img2
                source: img.source
                width: img.width*2
                height: img.height*2
                visible: false
                property bool mov: false
                onXChanged:{
                    mov=true
                    trm.restart()
                }
                onYChanged:{
                    mov=true
                    trm.restart()
                }
                Behavior on x{
                    NumberAnimation{duration:750;easing.type: Easing.InOutCubic}
                }
                Behavior on y{
                    NumberAnimation{duration:750;easing.type: Easing.InOutCubic}
                }

            }
            MouseArea{
                anchors.fill: img2
                //drag.target: parent
                //drag.axis: Drag.XAndYAxis
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    info.text=mouseX
                    /*if(mouse.modifiers) {
                        xMira.enabled=!xMira.enabled
                    }else{
                        img.x=0-mouseX+img.width*0.5
                        img.y=0-mouseY+img.height*0.5-40//(720-534)
                    }*/
                }
            }
            FastBlur {
                id: fb2
                anchors.fill: img2
                source: img2
                radius: 2
                visible: false
            }
            BrightnessContrast {
                anchors.fill: fb2
                source: fb2
                brightness: 0.35
                contrast: 0.7
            }
            Rectangle{
                anchors.fill: parent
                color: 'transparent'
                border.width: 2
                border.color: 'red'
                clip: true
            }
            XAreaInteractivaZoom{
                id: xAreaInteractivaZoom
                anchors.fill: img2
            }
            XMira{
                id: xMira
                w:app.fs*2.5
                visible: false
                anchors.fill: parent
                mov: false//enabled?img.mov:true
                property bool enabled: true
            }
        }
        Text{
            id: info
            text: app.mod
            font.pixelSize: 60
            color: 'red'
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }
        XNombre{
            id: xNombre
            XState{
                id: xState
                anchors.left: parent.right
            }
            XFormZS{
                id: xFormZS
                visible: false
            }
            XFormRS{
                id: xFormRS
            }
        }
        XTools{
            id: xTools
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
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
                let asp=jsonData.asp
                for(i=0;i<Object.keys(asp).length;i++){
                    if(asp['asp'+i].p!=='N.'&&asp['asp'+i].p!=='S.'){
                        let m0=(''+asp['asp'+i].p).toLowerCase().replace('N.', 'n').replace('S.', 's').replace('N.', 'n').replace('.', '').split('-')
                        let comp=Qt.createComponent('XAsp.qml')
                        let obj=comp.createObject(xAsp, {c1:m0[0], c2:m0[1], asp: asp['asp'+i].t})
                        //console.log('Asp: '+asp['asp'+i].t+' '+asp['asp'+i].p+' c1:'+m0[0]+' c2:'+m0[1])
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
            xAreaInteractiva.back()
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.down()
                return
            }
            xAreaInteractiva.next()
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
                xFormRS.minuto=app.currentMinutoSolar
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
            let obj=comp.createObject(app, {textData:'No hay datos disponibles.', width: app.fs*8, height: app.fs*3, fs: app.fs*0.5, title:'Sin datos'})
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
    function getEdad(dateString) {
        let hoy = new Date()
        let fechaNacimiento = new Date(dateString)
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
    function load(file){
        //console.log('Salida: '+file)
        apps.url=file
        console.log('Count apps.url='+apps.url)
        let fn=apps.url.replace('cap_', '').replace('.png', '')
        let jsonFileName=fn+'.json'//'/home/ns/temp-screenshots/'+ms+'.json'
        //console.log('FileName: '+jsonFileName)
        let jsonFileData=unik.getFile(jsonFileName)
        //console.log(jsonFileData)
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
        let numEdad=getEdad(""+va+"/"+vm+"/"+vd+" "+vh+":"+vmin+":00")
        let stringEdad=edad.indexOf('NaN')<0?edad:''
        let textData=''
        if(parseInt(numEdad)>0){
            edad=' <b>Edad:</b> '+numEdad
            textData=''
                    +'<b>'+nom+'</b>'
                    +'<p style="font-size:20px;">'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs GMT '+vgmt+stringEdad+'</p>'
                    +'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
                    +'<p style="font-size:20px;"> <b>long:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'
        }else{
            textData=''
                    +' <p><b>Revolución Solar</b></p> '
                    +'<b>'+nom+'</b>'
                    +'<p style="font-size:20px;"><b>Cumpleaños Astrológico: </b>'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs </p>'
            //+'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
            //+'<p style="font-size:20px;"> <b>long:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'

        }

        //Seteando datos globales de mapa energético
        app.currentDate= new Date(parseInt(va), parseInt(vm), parseInt(vd), parseInt(vh), parseInt(vmin))

        getCmdData.getData(vd, vm, va, vh, vmin, vlon, vlat, 0, vgmt)
        app.currentNom=nom
        app.currentFecha=vd+'/'+vm+'/'+va
        app.currentGradoSolar=jsonData.psc.sun.g
        app.currentMinutoSolar=jsonData.psc.sun.m
        app.currentLon=vlon
        app.currentLat=vlat
        //app.currentSegundoSolar=jsonData.pc.sun.s



        xNombre.nom=textData
        //xAreaInteractiva.loadData()
        //xAreaInteractivaZoom.loadData()
        tLoadData.restart()
        tReload.restart()
        xAsp.load(jsonData)
        homeCircle.load(jsonData)
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
        let jsonFileData=unik.getFile(jsonFileName)
        //console.log(jsonFileData)
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
        let numEdad=getEdad(""+va+"/"+vm+"/"+vd+" "+vh+":"+vmin+":00")
        let stringEdad=edad.indexOf('NaN')<0?edad:''
        let textData=''
        if(parseInt(numEdad)>0){
            edad=' <b>Edad:</b> '+numEdad
            textData=''
                    +'<b>'+nom+'</b>'
                    +'<p style="font-size:20px;">'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs GMT '+vgmt+stringEdad+'</p>'
                    +'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
                    +'<p style="font-size:20px;"> <b>long:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'
        }else{
            textData=''
                    +' <p><b>Revolución Solar</b></p> '
                    +'<b>'+nom+'</b>'
                    +'<p style="font-size:20px;"><b>Cumpleaños Astrológico: </b>'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs </p>'
            //+'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
            //+'<p style="font-size:20px;"> <b>long:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'

        }

        //Seteando datos globales de mapa energético
        app.currentDate= new Date(parseInt(va), parseInt(vm), parseInt(vd), parseInt(vh), parseInt(vmin))

        //getCmdData.getData(vd, vm, va, vh, vmin, vlon, vlat, 0, vgmt)
        app.currentNom=nom
        app.currentFecha=vd+'/'+vm+'/'+va
        //app.currentGradoSolar=jsonData.psc.sun.g
        //app.currentMinutoSolar=jsonData.psc.sun.m
        app.currentLon=vlon
        app.currentLat=vlat
        //app.currentSegundoSolar=jsonData.pc.sun.s



        xNombre.nom=textData
        //xAreaInteractiva.loadData()
        //xAreaInteractivaZoom.loadData()
        //tLoadData.restart()
        //tReload.restart()
        //xAsp.load(jsonData)
        sweg.load(jsonData)
    }
}
