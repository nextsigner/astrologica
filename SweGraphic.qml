import QtQuick 2.0

Item {
    id: r
    property bool v: false
    property alias expand: planetsCircle.expand
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
    SignCircle{
        id:signCircle
        width: planetsCircle.expand?app.fs*14:app.fs*12
        height: width
        anchors.centerIn: parent
        showBorder: true
        v:r.v
    }
    AspCircle{
        id: aspCircle
        rotation: signCircle.rotation - 90
    }
    PlanetsCircle{
        id:planetsCircle
        width: signCircle.width-app.fs*2
        height: width
        anchors.centerIn: parent
        //showBorder: true
        //v:r.v
    }
    function load(jsonData){
        //console.log('Ejecutando SweGraphic.load()...')
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let vd=jsonData.params.d
        let vm=jsonData.params.m
        let va=jsonData.params.a
        let vh=jsonData.params.h
        let vmin=jsonData.params.min
        let vgmt=jsonData.params.gmt
        let vlon=jsonData.params.lon
        let vlat=jsonData.params.lat
        let d = new Date(Date.now())
        let ms=d.getTime()
         let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        let json=(\'\'+logData)\n'
        c+='        loadSweJson(json)\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        console.log(\'python3 ./py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\'python3 ./py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcode')
    }
    function loadSweJson(json){
        //console.log('JSON::: '+json)
        let scorrJson=json.replace(/\n/g, '')
        let j=JSON.parse(scorrJson)
        signCircle.rotation=j.ph.h1.gdec
        housesCircle.loadHouses(j)
        planetsCircle.loadJson(j)
        xAsp.load(j)
        panelDataBodies.loadJson(j)
        aspCircle.load(j)
        r.v=true
    }
}
