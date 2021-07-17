import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "comps" as Comps
import "Funcs.js" as JS
Rectangle {
    id: r
    width: parent.width
    height: parent.height
    color: 'black'
    border.width: 2
    border.color: 'white'
    x:0-r.width
    property real lat
    property real lon
    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                x:0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                x:0-r.width
            }
        }
    ]
    Behavior on x{enabled: app.enableAn;NumberAnimation{duration: app.msDesDuration}}
    onStateChanged: {
        if(state==='show')tiNombre.t.focus=true
        //xApp.focus=true
    }
    onXChanged: {
        if(x===0){
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
        }
    }
    Column{
        id: col
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
                width: r.width-app.fs*0.5
                t.font.pixelSize: app.fs*0.65
                anchors.horizontalCenter: parent.horizontalCenter
                KeyNavigation.tab: tiFecha.t
                t.maximumLength: 30
            }
        }
        Row{
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{text:'Fecha:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
            Comps.XTextInput{
                id: tiFecha;
                width: app.fs*4;
                t.font.pixelSize: app.fs*0.65;
                c: true
                KeyNavigation.tab: tiHora.t
                t.inputMask: "00/00/0000"
            }
        }
        Row{
            //spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                spacing: app.fs*0.1
                Comps.XText{text:'Hora:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
                Comps.XTextInput{
                    id: tiHora;
                    width: app.fs*3;
                    t.font.pixelSize: app.fs*0.65;
                    c: true
                    KeyNavigation.tab: tiGMT.t
                    t.inputMask: "00:00"
                    t.color: valid?'white':'red'
                    property   bool valid: false
                    onTextChanged: {
                        let s=text.split(':')
                        if(s[0].length<2||s[1].length<2){
                            valid=false
                        }else{
                            valid=true
                        }
                    }
                }
            }
            Row{
                spacing: app.fs*0.1
                Comps.XText{text:'GMT:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
                Comps.XTextInput{
                    id: tiGMT;
                    width: app.fs*2;
                    t.font.pixelSize: app.fs*0.65;
                    c: true
                    KeyNavigation.tab: tiCiudad.t
                    t.validator: IntValidator {
                        bottom: parseInt(-11)
                        top: parseInt(12)
                    }
                }
            }
        }
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            Comps.XText{text:'Lugar:'; t.font.pixelSize: app.fs*0.35;height: app.fs*0.8}
            Comps.XTextInput{
                id: tiCiudad
                width: tiNombre.width
                t.font.pixelSize: app.fs*0.65;
                KeyNavigation.tab: botCrear
                t.maximumLength: 50
                onTextChanged: t.color='white'
            }
        }
        Button{
            id: botCrear
            text: 'Crear'
            font.pixelSize: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            KeyNavigation.tab: tiNombre.t
            onClicked: {
                searchGeoLoc()
            }
        }
    }
    Item{id: xuqp}
    function searchGeoLoc(){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let c='import QtQuick 2.0\n'
        c+='import unik.UnikQProcess 1.0\n'
        c+='UnikQProcess{\n'
        c+='    id: uqp'+ms+'\n'
        c+='    onLogDataChanged:{\n'
        c+='        let result=(\'\'+logData).replace(/\\n/g, \'\')\n'
        c+='        let json=JSON.parse(result)\n'
        c+='        if(json){\n'
        //c+='            console.log(JSON.stringify(json))\n'
        c+='                r.lat=json.coords.lat\n'
        c+='                r.lon=json.coords.lon\n'
        c+='                if(r.lat===-1&&r.lon===-1){\n'
        c+='                   tiCiudad.t.color="red"\n'
        c+='                }else{\n'
        c+='                   tiCiudad.t.color="white"\n'
        c+='                    setNewJsonFileData()\n'
        c+='                    r.state=\'hide\'\n'
        c+='                }\n'
        c+='        }else{\n'
        c+='            console.log(\'No se encontraron las cordenadas.\')\n'
        c+='        }\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        //c+='        console.log(\'python3 /home/ns/nsp/uda/astrologica/py/astrologica_swe.py '+vd+' '+vm+' '+va+' '+vh+' '+vmin+' '+vgmt+' '+vlat+' '+vlon+'\')\n'
        c+='        run(\'python3 /home/ns/nsp/uda/astrologica/py/geoloc.py "'+tiCiudad.t.text+'"\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodesign')
    }
    function setNewJsonFileData(){
        let d = new Date(Date.now())
        let ms=d.getTime()
        let nom=tiNombre.t.text.replace(/ /g, '_')

        let m0=tiFecha.t.text.split('/')
        if(m0.length!==3)return
        let vd=parseInt(m0[0])
        let vm=parseInt(m0[1])
        let va=parseInt(m0[2])

        m0=tiHora.t.text.split(':')
        let vh=parseInt(m0[0])
        let vmin=parseInt(m0[1])

        let vgmt=tiGMT.t.text
        let vlon=r.lon
        let vlat=r.lat
        let vCiudad=tiCiudad.t.text.replace(/_/g, ' ')
        let j='{'
        j+='"params":{'
        j+='"tipo":"vn",'
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
        nom=tiNombre.t.text.replace(/ /g, '_')
        unik.setFile(app.mainLocation+'/jsons/'+nom+'.json', app.currentData)
        //apps.url=app.mainLocation+'/jsons/'+nom+'.json'
        JS.loadJson(app.mainLocation+'/jsons/'+nom+'.json')
        //runJsonTemp()
    }
    function enter(){
        if(botCrear.focus){
            searchGeoLoc()
        }
    }
}
