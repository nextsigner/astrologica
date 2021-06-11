import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.12
import "comps" as Comps
import "Funcs.js" as JS
Rectangle {
    id: r
    width: parent.width
    height: app.fs*2
    color: 'black'
    border.width: 2
    border.color: 'white'
    y:r.parent.height
    property real lat
    property real lon
    state: 'hide'
    states: [
        State {
            name: "show"
            PropertyChanges {
                target: r
                y:r.parent.height-r.height
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: r
                y:r.parent.height
            }
        }
    ]
    Behavior on x{NumberAnimation{duration: 250}}
    onStateChanged: {
        if(state==='show')tiCmd.t.focus=true
    }
    onXChanged: {
        if(x===0){
            //txtDataSearch.selectAll()
            //txtDataSearch.focus=true
        }
    }
    Row{
        id: row
        anchors.centerIn: parent
        spacing: app.fs*0.25
        Row{
            spacing: app.fs*05
            anchors.verticalCenter: parent.verticalCenter
            Comps.XText{
                id: labelCmd
                text:'Comando:'
                t.color: 'white'
                t.font.pixelSize: app.fs*0.35
                height: app.fs*0.8
                //anchors.verticalCenter: parent.verticalCenter
            }
            Comps.XTextInput{
                id: tiCmd
                width: r.width-labelCmd.width-app.fs
                t.font.pixelSize: app.fs*0.65
                anchors.verticalCenter: parent.verticalCenter
                Keys.onReturnPressed: {
                    runCmd(text)
                }
                //KeyNavigation.tab: tiFecha.t
                //t.maximumLength: 30
            }
        }
    }
    Item{id: xuqp}
    function runCmd(cmd){
        for(var i=0;i<xuqp.children.length;i++){
            xuqp.children[i].destroy(0)
        }
        let d = new Date(Date.now())
        let ms=d.getTime()
        let finalCmd=''
        let c=''
        let comando=cmd.split(' ')
        if(comando.length<1)return
        if(comando[0]==='eclipse'){
            if(comando.length<5)return
            c=''
            //+'  console.log("Eclipse: "+logData)\n'
            +'  let json=JSON.parse(logData)\n'
            +'  r.state="hide"\n'
            +'  sweg.objEclipseCircle.setEclipse(json.gdec, json.rsgdeg, json.gdeg, json.mdeg, json.is)\n'
            finalCmd=''
            +'python3 ./py/astrologica_swe_search_eclipses.py '+comando[1]+' '+comando[2]+' '+comando[3]+' '+comando[4]+' '+comando[5]+''
        }
        mkCmd(finalCmd, c)
    }
    function mkCmd(finalCmd, code){
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
        c+='        '+code+'\n'
        c+='        uqp'+ms+'.destroy(0)\n'
        c+='    }\n'
        c+='    Component.onCompleted:{\n'
        c+='        run(\''+finalCmd+'\')\n'
        c+='    }\n'
        c+='}\n'
        let comp=Qt.createQmlObject(c, xuqp, 'uqpcodecmd')
    }
    function enter(){
        runCmd(tiCmd.text)
    }
}
