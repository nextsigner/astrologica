import QtQuick 2.0
import QtQuick.Controls 2.0
import "Funcs.js" as JS

Rectangle {
    id: r
    width: app.fs*6
    height: app.fs*3
    border.width: 2
    border.color: 'red'
    color: 'transparent'
    Column{
        spacing: app.fs*0.25
        anchors.centerIn: r
        Button{
            text: app.uSon
            width: app.fs*3
            height: app.fs*0.6
            anchors.horizontalCenter: parent.horizontalCenter
            visible: app.uSon!==''
            onClicked: {
                JS.showIW()
            }
        }
        Row{
            spacing: app.fs*0.25
            anchors.horizontalCenter: parent.horizontalCenter
            Button{
                visible: app.uSon.indexOf('asc_')===0||app.uSon.indexOf('mc_')===0||app.uSon.indexOf('sun_')===0
                text: 'S'
                width: app.fs*0.6
                height: app.fs*0.6
                onClicked: {
                    if(app.uSon.indexOf('asc_')===0){
                        JS.showSABIANOS(app.objSignsNames.indexOf(app.uSon.split('_')[1]), app.uAscDegree-1)
                    }
                    if(app.uSon.indexOf('mc_')===0){
                        JS.showSABIANOS(app.objSignsNames.indexOf(app.uSon.split('_')[1]), app.uMcDegree-1)
                    }
                    if(app.uSon.indexOf('sun_')===0){
                        JS.showSABIANOS(app.objSignsNames.indexOf(app.uSon.split('_')[1]), app.currentGradoSolar-1)
                    }
                }
            }
        }
    }    
}
