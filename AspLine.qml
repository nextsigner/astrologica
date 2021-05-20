import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width
    height: width
    color: 'transparent'
    radius: width*0.5
    border.width: 1
    border.color: 'red'
    antialiasing: true
    property int is: -1
    property real gdeg: -1
    property real dga: -1
    rotation: 90 + is * 30 + gdeg
    Rectangle{
        width: 8
        height: parent.height*2
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            width: 2
            height: 600
            color: 'blue'
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.top
            rotation: 0- (r.dga - 90)
            Rectangle{
                width: 5
                height: 5
                radius: width*0.5
                anchors.centerIn: parent
                color: 'red'
            }
        }
    }
}
