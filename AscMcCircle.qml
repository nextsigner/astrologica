import QtQuick 2.0

Item {
    id: r
    anchors.centerIn: parent
    property int is: 0
    property int gdegAsc: -1
    property int mdegAsc: -1
    Rectangle{
        id: ejeAsc
        width: r.width
        height: 1
        anchors.centerIn: parent
        color: 'transparent'
        Rectangle{
            width: housesCircle.w*0.5
            height: housesCircle.wb
            //border.width: 1
            //border.color: 'yellow'
            anchors.verticalCenter: parent.verticalCenter
            color: app.signColors[0]
        }
        Rectangle{
            width: app.fs*0.75
            height: housesCircle.wb
            //border.width: 1
            //border.color: 'green'
            anchors.verticalCenter: parent.verticalCenter
            color: 'transparent'
            anchors.right:  parent.left
            Rectangle{
                id: xLineaSup
                width: 1
                height: app.fs*0.45
                //border.width: 1
                //border.color: 'green'
                anchors.horizontalCenter: parent.left
                color: 'red'
                anchors.bottom: parent.top
                anchors.bottomMargin: app.fs*0.25
                Rectangle{
                    width: txt1.contentWidth
                    height: 1
                    border.width: 1
                    border.color: 'green'
                    anchors.horizontalCenter: parent.left
                    anchors.horizontalCenterOffset: 0-app.fs*0.25
                    color: app.signColors[0]
                    anchors.bottom: parent.top
                    Text{
                        id: txt1
                        text: '<b>Asc '+app.signos[r.is]
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                        anchors.bottom: parent.top
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        textFormat:  Text.RichText
                    }
                }
            }
            Rectangle{
                id: xLineaInf
                width: 1
                height: app.fs*0.45
                anchors.horizontalCenter: parent.left
                color: 'red'
                anchors.top: parent.bottom
                anchors.topMargin: app.fs*0.25
                Rectangle{
                    width: txt2.contentWidth
                    height: 1
                    border.width: 1
                    border.color: 'green'
                    anchors.horizontalCenter: parent.left
                    anchors.horizontalCenterOffset: 0-app.fs*0.25
                    color: app.signColors[0]
                    anchors.top: parent.bottom
                    Text{
                        id: txt2
                        text: '<b>°'+r.gdegAsc+' \''+r.mdegAsc+'</b>'
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                        anchors.top: parent.bottom
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        textFormat:  Text.RichText
                    }
                }
            }
        }
    }
    function loadJson(jsonData) {
        let o1=jsonData.ph['h1']
        r.is=o1.is
        r.gdegAsc=o1.rsgdeg
        r.mdegAsc=o1.mdeg
    }
}
