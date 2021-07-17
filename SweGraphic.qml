import QtQuick 2.7

Item {
    id: r
    //width:app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3
    height: width
    anchors.centerIn: parent
    //anchors.horizontalCenterOffset: r.fs*10
    property int fs: r.objectName==='sweg'?app.fs:app.fs*2
    property bool v: false
    property alias expand: planetsCircle.expand
    property alias objAspsCircle: aspsCircle
    property alias objPlanetsCircle: planetsCircle
    property alias objHousesCircle: housesCircle
    property alias objSignsCircle: signCircle
    property alias objSignsCircleDec: signCircleDec
    property alias objAscMcCircle: ascMcCircle
    property alias objEclipseCircle: eclipseCircle
    property int speedRotation: 1000
    property var aStates: ['ps', 'pc', 'pa']
    state: aStates[0]
    states: [
        State {//PS
            name: aStates[0]
            PropertyChanges {
                target: r
                //width: r.objectName==='sweg'?(app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3):(app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3)*2
                width: r.objectName==='sweg'?(app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3):(app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3)*2
            }
        },
        State {//PC
            name: aStates[1]
            PropertyChanges {
                target: r
                width: r.objectName==='sweg'?(app.currentPlanetIndex!==16?r.parent.height:r.parent.height):(app.currentPlanetIndex!==16?r.parent.height:r.parent.height)*2
            }            
        },
        State {//PA
            name: aStates[2]
            PropertyChanges {
                target: r
                width: r.objectName==='sweg'?(app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3):(app.currentPlanetIndex!==16?r.parent.height:r.parent.height-r.fs*3)*2
            }            
        }
    ]
    onStateChanged: swegz.sweg.state=state
    Item{id: xuqp}
    Rectangle{
        id: bg
        width: parent.width*10
        height: width
        color: 'transparent'
        visible: signCircle.v
    }
    PanelAspects{
        id: panelAspects
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0-((xApp.width-r.width)/2)+swegz.width
        visible: r.objectName==='sweg'
        //Rectangle{anchors.fill: parent; color: 'red';border.width: 1;border.color: 'white'}
    }
    HomeCircle{
        id:housesCircle
        height: width
        anchors.centerIn: signCircle
        showBorder: true
        rotation: -90
        w: r.fs*6
        widthAspCircle: aspsCircle.width
        visible: r.v
        //z: ascMcCircle.z+1
    }
    SignCircleDec{
        id:signCircleDec
        width: signCircle.width-signCircle.w*0.5+1
        height: width
        anchors.centerIn: parent
        showBorder: false
        v:r.v
        w: r.state==='ps'?r.fs:r.fs*0.5
        //visible: false
    }
    SignCircleDec2{
        id:signCircleDec2
        width: signCircleDec.width-(signCircle.w*0.5)*2+1
        height: width
        anchors.centerIn: parent
        showBorder: false
        v:r.v
        w: r.state==='ps'?r.fs:r.fs*0.5
        //visible: false
    }
    SignCircle{
        id:signCircle
        width: planetsCircle.expand?r.width-r.fs*6+r.fs*2:r.width-r.fs*6
        height: width
        anchors.centerIn: parent
        showBorder: true
        v:r.v
        w: r.state==='ps'?r.fs:r.fs*0.5
        //visible: false
    }
    AspCircle{
        id: aspsCircle
        rotation: signCircle.rot - 90
        //opacity: panelDataBodies.currentIndex<0?1.0:0.0
    }
    PlanetsCircle{
        id:planetsCircle
        height: width
        anchors.centerIn: parent
        //showBorder: true
        //v:r.v
    }
    AscMcCircle{
        id: ascMcCircle
        width: housesCircle.width
        height: width
    }

    EclipseCircle{
        id: eclipseCircle
        width: housesCircle.width
        height: width
    }

    Rectangle{
        //Este esta en el centro
        visible: false
        opacity: 0.5
        width: r.fs*2//planetsCircle.children[0].fs*0.85+4
        height: width
        color: 'red'
        radius: width*0.5
        border.width: 2
        border.color: 'white'
        anchors.centerIn: parent
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
        c+='        panelControlsSign.loadJson(app.currentJsonSignData)\n'
        c+='        app.mod="pl"\n'
        c+='        if(panelZonaMes.state===\'show\')panelZonaMes.play()\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        //console.log(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe_search_asc_aries.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodesign')
    }
    function load(j){
        //console.log('Ejecutando SweGraphic.load()...')
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
        c+='        let json=(\'\'+logData)\n'
        c+='        //console.log(\'JSON: \'+json)\n'
        c+='        loadSweJson(json)\n'
        c+='        swegz.sweg.loadSweJson(json)\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\'sweg.load() python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcode')
    }
    function loadSweJson(json){
        //console.log('JSON::: '+json)
        sweg.objHousesCircle.currentHouse=-1
        swegz.sweg.objHousesCircle.currentHouse=-1
        app.currentPlanetIndex=-1
        let scorrJson=json.replace(/\n/g, '')
        let j=JSON.parse(scorrJson)
        signCircle.rot=j.ph.h1.gdec
        signCircleDec.rot=j.ph.h1.gdec
        signCircleDec2.rot=j.ph.h1.gdec
        ascMcCircle.loadJson(j)
        housesCircle.loadHouses(j)
        planetsCircle.loadJson(j)
        panelAspects.load(j)
        panelDataBodies.loadJson(j)
        aspsCircle.load(j)
        eclipseCircle.arrayWg=housesCircle.arrayWg
        eclipseCircle.isEclipse=-1
        if(app.mod!=='rs'&&app.mod!=='pl'&&panelZonaMes.state!=='show')panelRsList.setRsList(61)
        r.v=true
    }
    function nextState(){
        let currentIndexState=r.aStates.indexOf(r.state)
        if(currentIndexState<r.aStates.length-1){
            currentIndexState++
        }else{
            currentIndexState=0
        }
        r.state=r.aStates[currentIndexState]
        swegz.sweg.state=r.state
    }
}
