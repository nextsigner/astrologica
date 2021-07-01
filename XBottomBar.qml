import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width
    height: 0
    color: 'black'
    anchors.bottom: parent.bottom
    property alias objPanelCmd: panelCmd
    state: "hide"
    states: [
        State {
            name: "hide"
            PropertyChanges {
                target: r
                height: 0
            }
        },
        State {
            name: "show"
            PropertyChanges {
                target: r
                height: app.fs
            }
        }
    ]
    Behavior on height {NumberAnimation{duration: 500;easing.type: Easing.InOutQuad}}
    PanelCmd{
        id: panelCmd
        onStateChanged: r.state=state
    }
}
