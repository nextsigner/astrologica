import QtQuick 2.0

Rectangle {
    id: r
    height: width
    border.width: 1
    border.color: 'gray'
    color: indexAsp!==-1?arrColors[indexAsp]:'transparent'
    property var arrColors: ['red','#ff8833',  'green', '#124cb1']
    property int indexAsp: -1
    property int indexPosAsp: -1
    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(sweg.objAspsCircle.currentAspSelected!==r.indexPosAsp){
                sweg.objAspsCircle.currentAspSelected=r.indexPosAsp
                swegz.sweg.objAspsCircle.currentAspSelected=r.indexPosAsp
            }else{
                sweg.objAspsCircle.currentAspSelected=-1
                swegz.sweg.objAspsCircle.currentAspSelected=-1
            }
        }
    }
    Text{
        text:'<b>'+r.indexPosAsp+'</b>'
        font.pixelSize: 10
        anchors.centerIn: parent
        color: 'white'
        visible: r.indexPosAsp!==-1
    }
}
