import QtQuick 2.0
import QtCanvas3D 1.0

import "planets.js" as GLCode

Item {
    id: mainview
    anchors.fill: parent

    property int canvas3dX: 0
    property int canvas3dY: 0
    property int canvas3dWidth: 400
    property int canvas3dHeight: 400

    property alias lm: planetModel

    property int focusedPlanet: 0
    property int oldPlanet: 0
    property real xLookAtOffset: 0
    property real yLookAtOffset: 0
    property real zLookAtOffset: 0
    property real xCameraOffset: 0
    property real yCameraOffset: 0
    property real zCameraOffset: 0
    property real cameraNear: 0
    property int sliderLength: (width < height) ? width / 2 : height / 2
    property real textSize: (sliderLength < 320) ? (sliderLength / 20) : 16
    property real planetButtonSize: (height < 768) ? (height / 11) : 70

    NumberAnimation {
        id: lookAtOffsetAnimation
        target: mainview
        properties: "xLookAtOffset, yLookAtOffset, zLookAtOffset"
        to: 0
        easing.type: Easing.InOutQuint
        duration: 1250
    }

    NumberAnimation {
        id: cameraOffsetAnimation
        target: mainview
        properties: "xCameraOffset, yCameraOffset, zCameraOffset"
        to: 0
        easing.type: Easing.InOutQuint
        duration: 2500
    }

    Behavior on cameraNear {
        PropertyAnimation {
            easing.type: Easing.InOutQuint
            duration: 2500
        }
    }
    //! [1]
    onFocusedPlanetChanged: {
        if (focusedPlanet == 100) {
            info.opacity = 0;
            updatePlanetInfo();
        } else {
            updatePlanetInfo();
            info.opacity = 0.5;
        }

        GLCode.prepareFocusedPlanetAnimation();

        lookAtOffsetAnimation.restart();
        cameraOffsetAnimation.restart();
    }
    //! [1]
    //! [0]
    Canvas3D {
        id: canvas3d
        x: mainview.canvas3dX
        y: mainview.canvas3dY
        width: mainview.canvas3dWidth
        height: mainview.canvas3dHeight
        //anchors.fill: parent
        //! [4]
        onInitializeGL: {
            GLCode.initializeGL(canvas3d, eventSource, mainview);
        }
        //! [4]
        onPaintGL: {
            GLCode.paintGL(canvas3d);
            fpsDisplay.fps = canvas3d.fps;
        }

        onResizeGL: {
            GLCode.onResizeGL(canvas3d);
        }
        //! [3]
        ControlEventSource {
            anchors.fill: parent
            focus: true
            id: eventSource
        }
        //! [3]
    }
    //! [0]
    ListModel {
        id: planetModel
        function addPlanets(nom,s,num){
            return{
                name:nom,
                radius:"",
                temperature:"",
                orbitalPeriod: "",
                distance: "",
                planetImageSource:s,
                planetNumber:num
            }
        }
        /*ListElement {
            name: "Sol"
            radius: "109 x Tierra"
            temperature: "5 778 K"
            orbitalPeriod: ""
            distance: ""
            planetImageSource: "images/sun.png"
            planetNumber: 0
        }
        ListElement {
            name: "Mercurio"
            radius: "0.3829 x Tierra"
            temperature: "80-700 K"
            orbitalPeriod: "87.969 d"
            distance: "0.387 098 AU"
            planetImageSource: "images/mercury.png"
            planetNumber: 1
        }        
        ListElement {
            name: "Venus"
            radius: "0.9499 x Tierra"
            temperature: "737 K"
            orbitalPeriod: "224.701 d"
            distance: "0.723 327 AU"
            planetImageSource: "images/venus.png"
            planetNumber: 2
        }
        ListElement {
            name: "Tierra"
            radius: "6 378.1 km"
            temperature: "184-330 K"
            orbitalPeriod: "365.256 d"
            distance: "149598261 km (1 AU)"
            planetImageSource: "images/earth.png"
            planetNumber: 3
        }
        ListElement {
            name: "Marte"
            radius: "0.533 x Tierra"
            temperature: "130-308 K"
            orbitalPeriod: "686.971 d"
            distance: "1.523679 AU"
            planetImageSource: "images/mars.png"
            planetNumber: 4
        }
        ListElement {
            name: "Jupiter"
            radius: "11.209 x Tierra"
            temperature: "112-165 K"
            orbitalPeriod: "4332.59 d"
            distance: "5.204267 AU"
            planetImageSource: "images/jupiter.png"
            planetNumber: 5
        }
        ListElement {
            name: "Saturno"
            radius: "9.4492 x Tierra"
            temperature: "84-134 K"
            orbitalPeriod: "10759.22 d"
            distance: "9.5820172 AU"
            planetImageSource: "images/saturn.png"
            planetNumber: 6
        }
        ListElement {
            name: "Urano"
            radius: "4.007 x Tierra"
            temperature: "49-76 K"
            orbitalPeriod: "30687.15 d"
            distance: "19.189253 AU"
            planetImageSource: "images/uranus.png"
            planetNumber: 7
        }
        ListElement {
            name: "Neptuno"
            radius: "3.883 x Tierra"
            temperature: "55-72 K"
            orbitalPeriod: "60190.03 d"
            distance: "30.070900 AU"
            planetImageSource: "images/neptune.png"
            planetNumber: 8
        }
        ListElement {
            name: "Sistema Solar"
            planetImageSource: ""
            planetNumber: 100 // Defaults to solar system
        }*/
    }

    Component {
        id: planetButtonDelegate
        PlanetButton {
            source: planetImageSource
            text: name
            focusPlanet: planetNumber
            planetSelector: mainview
            buttonSize: planetButtonSize
            fontSize: textSize
        }
    }

    ListView {
        id: planetButtonView
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: planetButtonSize / 5
        anchors.bottomMargin: planetButtonSize / 7
        spacing: planetButtonSize / 7
        width: planetButtonSize * 1.4
        interactive: false
        model: planetModel
        delegate: planetButtonDelegate
    }

    InfoSheet {
        id: info
        width: 400
        anchors.right: planetButtonView.left
        anchors.rightMargin: 10
        opacity: 0.5
        visible: false
        // Set initial information for Solar System
        planet: "Sistema Solar"
        exampleDetails: "Sistema Solar para Astrología</p>" +
                        "<p>Se ha creado este proyecto para mostrar los planetas de un modo sencillo</p>"
    }

    function updatePlanetInfo() {

        info.width = 200;

        if (focusedPlanet !== 100) {
            info.planet = planetModel.get(focusedPlanet).name
            info.radius = planetModel.get(focusedPlanet).radius
            info.temperature = planetModel.get(focusedPlanet).temperature
            info.orbitalPeriod = planetModel.get(focusedPlanet).orbitalPeriod
            info.distance = planetModel.get(focusedPlanet).distance
        }
    }

    StyledSlider {
        id: speedSlider
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: sliderLength
        value: 0.1
        minimumValue: 0
        maximumValue: 1
        onValueChanged: GLCode.onSpeedChanged(value);
        visible: false
    }
    Text {
        anchors.right: speedSlider.left
        anchors.verticalCenter: speedSlider.verticalCenter
        anchors.rightMargin: 10
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Rotation Speed"
        visible: false
    }

    StyledSlider {
        id: scaleSlider
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: sliderLength
        value: 1200
        minimumValue: 1
        maximumValue: 2000
        onValueChanged: GLCode.setScale(value);
        visible: false
    }
    Text {
        anchors.right: scaleSlider.left
        anchors.verticalCenter: scaleSlider.verticalCenter
        anchors.rightMargin: 10
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Planet Size"
        visible: false
    }

    StyledSlider {
        id: distanceSlider
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        orientation: Qt.Vertical
        height: sliderLength
        value: 1
        minimumValue: 1
        maximumValue: 2
        //! [2]
        onValueChanged: GLCode.setCameraDistance(value);
        //! [2]
        visible: false
    }
    Text {
        y: distanceSlider.y + distanceSlider.height + width + 10
        x: distanceSlider.x + 30 - textSize
        transform: Rotation {
            origin.x: 0;
            origin.y: 0;
            angle: -90
        }
        font.family: "Helvetica"
        font.pixelSize: textSize
        font.weight: Font.Light
        color: "white"
        text: "Viewing Distance"
        visible: false
    }

    // FPS display, initially hidden, clicking will show it
    FpsDisplay {
        id: fpsDisplay
        anchors.left: parent.left
        anchors.top: parent.top
        width: 32
        height: 64
        hidden: true
    }
    Text{
        id: txt
        font.pixelSize: 50
        color: 'red'
        text :'-><b>'+focusedPlanet+'</b>'
        visible: false
    }
    function add(nom, s, num){
        lm.append(lm.addPlanets(nom, s, num))
    }
    function setPlanet(n){
        var SUN = 0;
        var MERCURY = 1;
        var VENUS = 2;
        var EARTH = 3;
        var MARS = 4;
        var JUPITER = 5;
        var SATURN = 6;
        var URANUS = 7;
        var NEPTUNE = 8;
        var PLUTO = 10;
        var NUM_SELECTABLE_PLANETS = 9;
        var MOON = 9;
        var SOLAR_SYSTEM = 100;
        //planetasRes: ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 'n', 's', 'hiron', 'selena', 'lilith']
        if(n===0){
            focusedPlanet=SUN
        }
        if(n===1){
            focusedPlanet=MOON
        }
        if(n===2){
            focusedPlanet=MERCURY
        }
        if(n===3){
            focusedPlanet=VENUS
        }
        if(n===4){
            focusedPlanet=MARS
        }
        if(n===5){
            focusedPlanet=JUPITER
        }
        if(n===6){
            focusedPlanet=SATURN
        }
        if(n===7){
            focusedPlanet=URANUS
        }
        if(n===8){
            focusedPlanet=NEPTUNE
        }
        if(n===9){
            focusedPlanet=PLUTO
        }
    }
}
