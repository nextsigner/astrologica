function setFs() {
    let w = Screen.width
    let h = Screen.height
    if(w===1920 && h === 1080){
        app.fs = w*0.031
    }
    if(w===1680 && h === 1050){
        app.fs = w*0.036
    }
    if(w===1400 && h === 1050){
        app.fs = w*0.041
    }
    if(w===1600 && h === 900){
        app.fs = w*0.031
    }
    if(w===1280 && h === 1024){
        app.fs = w*0.045
    }
    if(w===1440 && h === 900){
        app.fs = w*0.035
    }
    if(w===1280 && h === 800){
        app.fs = w*0.035
    }
    if(w===1152 && h === 864){
        app.fs = w*0.042
    }
    if(w===1280 && h === 720){
        app.fs = w*0.03
    }
}


//VNA

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
    //Global Vars Reset
    app.currentPlanetIndex=-1
    app.currentSignIndex= 0
    app.currentNom= ''
    app.currentFecha= ''
    app.currentGradoSolar= -1
    app.currentMinutoSolar= -1
    app.currentSegundoSolar= -1
    app.currentGmt= 0
    app.currentLon= 0.0
    app.currentLat= 0.0
    app.uSon=''

    apps.url=file
    let fn=apps.url
    let jsonFileName=fn
    let jsonFileData=unik.getFile(jsonFileName).replace(/\n/g, '')
    app.fileData=jsonFileData
    let jsonData=JSON.parse(jsonFileData)
    if(parseInt(jsonData.params.ms)===0){
        panelDataBodies.enabled=true
        let d=new Date(Date.now())
        jsonData.params.d=d.getDate()
        jsonData.params.m=d.getMonth()
        jsonData.params.a=d.getFullYear()
        jsonData.params.h=d.getHours()
        jsonData.params.min=d.getMinutes()
        sweg.loadSign(jsonData)
    }else{
        panelDataBodies.enabled=false
        sweg.load(jsonData)
    }
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
                +'<b> Edad:</b>'+getEdad(vd, vm, va, vh, vmin)+' '
                +'<b> '+vCiudad+'</b> '
                +'<b>lon:</b> '+vlon+' <b>lat:</b> '+vlat+' '
    }else{
        textData=''
                +'<b>Revolución Solar</b></p> '
                +'<b>'+nom+'</b> '
                +'<b>Cumpleaños Astrológico: </b>'+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs '
        //+'<p style="font-size:20px;"><b> '+vCiudad+'</b></p>'
        //+'<p style="font-size:20px;"> <b>lon:</b> '+vlon+' <b>lat:</b> '+vlat+'</p>'

    }

    //Seteando datos globales de mapa energético
    app.currentDate= new Date(parseInt(va), parseInt(vm) - 1, parseInt(vd), parseInt(vh), parseInt(vmin))
    //console.log('2 main.loadJson('+file+'): '+app.currentDate.toString())

    //getCmdData.getData(vd, vm, va, vh, vmin, vlon, vlat, 0, vgmt)
    app.currentNom=nom
    app.currentFecha=vd+'/'+vm+'/'+va
    app.currentGmt=vgmt
    app.currentLon=vlon
    app.currentLat=vlat

    xDataBar.fileData=textData
    xDataBar.state='show'
    app.currentData=app.fileData
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
    //console.log('json: '+JSON.stringify(jsonData))
    //console.log('json2: '+jsonData.params)
    let d = new Date(Date.now())
    let ms=jsonData.params.ms
    let nom=jsonData.params.n.replace(/_/g, ' ')

    console.log('Date: '+date.toString())
    let vd=date.getDate()
    let vm=date.getMonth()+1
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
    loadJson(apps.url)
}

function loadJsonNow(file){
    let fn=file
    let jsonFileName=fn
    let jsonFileData=unik.getFile(jsonFileName).replace(/\n/g, '')
    //console.log('main.loadJson('+file+'):'+jsonFileData)

    let json=JSON.parse(jsonFileData)
    let d=new Date(Date.now())
    let o=json.params
    o.ms=d.getTime()
    o.d=d.getDate()
    o.m=d.getMonth()
    o.a=d.getFullYear()
    o.h=d.getHours()
    o.min=d.getMinutes()
    o.n=(o.n+' '+o.d+'-'+o.m+'-'+o.a+'-'+o.h+':'+o.min).replace(/Ahora/g, '').replace(/ahora/g, '')
    json.params=o
    sweg.loadSign(json)
    let nom=o.n.replace(/_/g, ' ')
    let vd=o.d
    let vm=o.m
    let va=o.a
    let vh=o.h
    let vmin=o.min
    let vgmt=o.gmt
    let vlon=o.lon
    let vlat=o.lat
    let vCiudad=o.ciudad.replace(/_/g, ' ')
    let edad=''
    let numEdad=getEdad(parseInt(va), parseInt(vm), parseInt(vd), parseInt(vh), parseInt(vmin))
    let stringEdad=edad.indexOf('NaN')<0?edad:''
    let textData=''

    textData=''
            +'<b>'+nom+'</b> '
            +''+vd+'/'+vm+'/'+va+' '+vh+':'+vmin+'hs GMT '+vgmt+stringEdad+' '
            +'<b> Edad:</b>'+getEdad(vd, vm, va, vh, vmin)+' '
            +'<b> '+vCiudad+'</b> '
            +'<b>lon:</b> '+vlon+' <b>lat:</b> '+vlat+' '

    //Seteando datos globales de mapa energético
    app.currentDate= new Date(parseInt(va), parseInt(vm) - 1, parseInt(vd), parseInt(vh), parseInt(vmin))
    //console.log('2 main.loadJson('+file+'): '+app.currentDate.toString())

    //getCmdData.getData(vd, vm, va, vh, vmin, vlon, vlat, 0, vgmt)
    app.currentNom=nom
    app.currentFecha=vd+'/'+vm+'/'+va
    app.currentGmt=vgmt
    app.currentLon=vlon
    app.currentLat=vlat

    xDataBar.fileData=textData
    xDataBar.state='show'
    app.currentData=app.fileData
    app.fileData=jsonFileData
}
