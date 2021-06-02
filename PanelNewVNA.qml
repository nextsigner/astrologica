import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "comps" as Comps

Rectangle {
    id: r
    width: parent.width*0.25
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:0-r.width
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:0
            }
        }
    ]
    Behavior on x{NumberAnimation{duration: 250}}
    onStateChanged: {
        if(state==='show')tiNombre.t.focus=true
        //xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            txtDataSearch.selectAll()
            txtDataSearch.focus=true
        }
    }
    Column{
        anchors.centerIn: parent
        spacing: app.fs*0.25
        Text{
            text: '<b>Creando VNA</b>'
            font.pixelSize: app.fs
            color: 'white'
        }
        Item{width: 1;height: app.fs*0.5}
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{
                text:'Nombre:'
                t.font.pixelSize: app.fs*0.35
                height: app.fs*0.8
            }
            Comps.XTextInput{
                id: tiNombre
                width: r.width-app.fs*0.25
                t.font.pixelSize: app.fs*0.65
                anchors.horizontalCenter: parent.horizontalCenter
                KeyNavigation.tab: tiFecha.t
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{text:'Fecha:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
            Comps.XTextInput{
                id: tiFecha;
                width: app.fs*4;
                t.font.pixelSize: app.fs*0.65;
                c: true
                KeyNavigation.tab: tiHora.t
            }
        }
        Row{
            //spacing: app.fs*0.05
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                Comps.XText{text:'Hora:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
                Comps.XTextInput{
                    id: tiHora;
                    width: app.fs*4;
                    t.font.pixelSize: app.fs*0.65;
                    c: true
                    KeyNavigation.tab: tiGMT.t
                }
            }
            Row{
                Comps.XText{text:'GMT:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
                Comps.XTextInput{
                    id: tiGMT;
                    width: app.fs*2;
                    t.font.pixelSize: app.fs*0.65;
                    c: true
                    KeyNavigation.tab: tiCiudad.t
                }
            }
        }
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{text:'Lugar:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
            Comps.XTextInput{
                id: tiCiudad
                KeyNavigation.tab: tiNombre.t
            }
        }
        Button{
            text: 'Crear'
            font.pixelSize: app.fs
            anchors.right: parent.right
            onClicked: {

            }
        }
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

}
