import QtQuick 2.7

Item {
    id: r
    property bool v: false
    property alias expand: planetsCircle.expand
    property alias objAspsCircle: aspsCircle
    property alias objPlanetsCircle: planetsCircle
    property alias objHousesCircle: housesCircle
    property int speedRotation: 1000
    Item{id: xuqp}
    Rectangle{
        width: parent.width*10
        height: width
        color: 'black'
        visible: signCircle.v
    }
    HomeCircle{
        id:housesCircle
        width: signCircle.width+app.fs*0.2
        height: width
        anchors.centerIn: signCircle
        showBorder: true
        rotation: -90
        w: app.fs*6
        visible: r.v
    }
    AscMcCircle{
        id: ascMcCircle
        width: housesCircle.width
        height: width
    }
    SignCircle{
        id:signCircle
        width: planetsCircle.expand?r.width-app.fs*6+app.fs*2:r.width-app.fs*6
        height: width
        anchors.centerIn: parent
        showBorder: true
        v:r.v
    }
    AspCircle{
        id: aspsCircle
        rotation: signCircle.rot - 90
        opacity: panelDataBodies.currentIndex<0?1.0:0.0
    }
    PlanetsCircle{
        id:planetsCircle
        width: signCircle.width-app.fs*2
        height: width
        anchors.centerIn: parent
        //showBorder: true
        //v:r.v
    }
    Rectangle{
        //Este esta en el centro
        visible: false
        opacity: 0.5
        width: planetsCircle.children[0].fs*0.85+4
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
        //c+='        console.log(\'JSON: \'+json)\n'
        c+='        loadSweJson(json)\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        //console.log(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcode')
    }
    function loadSweJson(json){
        //console.log('JSON::: '+json)
        let scorrJson=json.replace(/\n/g, '')
        let j=JSON.parse(scorrJson)
        signCircle.rot=j.ph.h1.gdec
        ascMcCircle.loadJson(j)
        housesCircle.loadHouses(j)
        planetsCircle.loadJson(j)
        xAsp.load(j)
        panelDataBodies.loadJson(j)
        aspsCircle.load(j)
        r.v=true
    }
}
