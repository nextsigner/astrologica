import QtQuick 2.0

Rectangle {
    id: r
    height: width
    border.width: 1
    border.color: 'gray'
    color: indexAsp!==-1?arrColors[indexAsp]:'transparent'
    property var arrColors: ['red','#ff8833',  'green', '#124cb1']
    property int indexAsp: -1
}
