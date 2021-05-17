import QtQuick 2.0

Item {
    id: r
    Rectangle{
        width: parent.width*10
        height: width
        color: 'black'
        visible: signCircle.v
    }
    HomeCircle{
        id:homeCircle
        width: signCircle.width+app.fs
        height: width
        anchors.centerIn: signCircle
        showBorder: true
        rotation: -90
        w: app.fs*3
        visible: signCircle.v
    }
    SignCircle{
        id:signCircle
        width: app.fs*12
        height: width
        anchors.centerIn: parent
        showBorder: true
    }
    function load(jsonData){
        console.log('Ejecutando SweGraphic.load()...')
        let vd=jsonData.params.d
        let vm=jsonData.params.m
        let va=jsonData.params.a
        let vh=jsonData.params.h
        let vmin=jsonData.params.min
        let vgmt=jsonData.params.gmt
        let vlon=jsonData.params.lon
        let vlat=jsonData.params.lat

         let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp\n'
        c+='    onLogDataChanged:{\n'
        c+='        let json=(\'\'+logData)\n'
        c+='        loadSweJson(json)\n'
        c+='        uqp.destroy(1)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        run(\'python3 ./py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, r, 'uqpcode')
    }
    function loadSweJson(json){
        console.log('JSON::: '+json)
        signCircle.v=true
    }
}
