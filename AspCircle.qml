import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width*0.5
    height: width
    radius: width*0.5
    color: 'black'
    border.width: 2
    border.color: 'white'
    anchors.centerIn: parent
    antialiasing: true
    /*Item{
        id: xAspLines
        anchors.fill: parent
        AspLine{
            is: 4
            gdeg: 14
            dga: 114.2662303516578
            //rotation: 45
        }
    }*/
    Canvas {
        id:canvas
        width: r.width//-app.fs
        height: width
        property var json
        onJsonChanged: requestPaint()
        onPaint:{
            var ctx = canvas.getContext('2d');
            ctx.reset();
            var x = canvas.width*0.5;
            var y = canvas.height*0.5;
            var radius=canvas.width*0.5-2
            ctx.beginPath();
            ctx.arc(x, y, radius, 0, 2 * Math.PI);
            ctx.lineWidth = 2
            ctx.strokeStyle = 'red';
            ctx.stroke();

            var cx=canvas.width*0.5
            var cy=canvas.height*0.5
            var pa1=gCoords(0)
            var pa2=gCoords(10)
            //var px2=radius*0.5
            //var py2=radius*0.5//canvas.width*0.5

            //Dibujo circulo en el centro
            drawPoint(ctx, radius-3, 0, 3, 'yellow')
            //drawPoint(ctx, cx, cy, 10, '#ff8833')

            //drawLine(ctx, x, y, px2, py2)
            //drawPoint(ctx, x, y, 3, 'green')

            //Dibujo punto inicio en Aries
            //drawLine(ctx, radius-3, 0, px3+cx, py3+cy)
            let asp=json.asps
            for(var i=0;i<Object.keys(asp).length;i++){
                if(asp['asp'+parseInt(i +1)]){
                    let a=asp['asp'+parseInt(i +1)]
                    console.log('Asp: '+'asp'+parseInt(i +1))
                    //let comp=Qt.createComponent('XAsp.qml')
                    //let obj=comp.createObject(xAsp, {c1:a.c1, c2:a.c2, ic1:a.ic1, ic2:a.ic2, tipo:a.ia})
                    let colorAsp='black'
                    //# -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono
                    if(a.ia===0){
                        colorAsp='red'
                    }
                    if(a.ia===1){
                        colorAsp='#ff8833'
                    }
                    if(a.ia===2){
                        colorAsp='green'
                    }
                    if(a.ia===3){
                        colorAsp='blue'
                    }
                    drawAsp(ctx, cx, cy, a.gdeg1, a.gdeg2, colorAsp)
                }
            }


            punto.x=cx+coords[0]//px3//newPoint.x
            punto.y=cy+coords[1]//py3//newPoint.y


        }
        function drawPoint(ctx, x, y, r, c){
            ctx.beginPath();
            ctx.arc(x, y, r, 0, 2 * Math.PI);
            ctx.lineWidth = 2
            ctx.strokeStyle = c;
            ctx.stroke();
        }
        function drawAsp(ctx, cx, cy, gdeg1, gdeg2, c){
            var angulo= gdeg1
            var coords=gCoords(radius, angulo)
            var px1 = coords[0]
            var py1 = coords[1]
            angulo= gdeg2
            coords=gCoords(radius, angulo)
            var px2 = coords[0]
            var py2 = coords[1]
            drawLine(ctx, px1+cx, py1+cy, px2+cx, py2+cy, c)
        }

        function drawLine(ctx, px1, py1, px2, py2, c){
            ctx.beginPath();
            ctx.moveTo(px1, py1);
            ctx.lineTo(px2, py2);
            ctx.lineWidth = 4
            ctx.strokeStyle = c;
            ctx.stroke();
        }
        function findNewPoint(x, y, angle, distance) {
            var result = {};

            result.x = Math.round(Math.cos(angle * Math.PI / 180) * distance + x);
            result.y = Math.round(Math.sin(angle * Math.PI / 180) * distance + y);

            return result;
        }
        function gCoords(radius, angle) {
            var d = Math.PI/180 //to convert deg to rads
            var deg
            var x
            var y
            deg = (360 - angle - 90) * d
            x = radius * Math.cos(deg)
            y = radius * Math.sin(deg)
            /*if (angle >= 0 & angle <= 45){
                deg = (180 + 90 -angle) * d
                x = radius * Math.cos(deg)
                y = radius * Math.sin(deg)
            }else if( angle > 45 & angle <= 90){
                deg = (270 - angle) * d
                x = radius * Math.sin(deg)
                y = radius * Math.cos(deg)
            }else if( angle > 90 & angle <= 135){
                deg = (90 - angle) * d
                x = radius * Math.sin(deg)
                y = radius * Math.cos(deg)
            }else if( angle > 135 & angle <= 180){
                deg = (180+angle) * d
                x = radius * Math.sin(deg)
                y = radius * Math.cos(deg)
            }else if( angle > 180 & angle <= 225){
                deg = (180+angle) * d
                x = radius * Math.sin(deg)
                y = radius * Math.cos(deg)
            }else if( angle > 225 & angle <= 270){
                deg = (180+angle) * d
                x = radius * Math.sin(deg)
                y = radius * Math.cos(deg)
            }else if( angle > 270 & angle <= 315){
                deg = (180+angle) * d
                x = radius * Math.sin(deg)
                y = radius * Math.cos(deg)
            }*/
            //console.log("x = " + x)
            //console.log("y = " + y)
            return [ x, y ];
        }
        function clear_canvas() {
            var ctx = getContext("2d");
            ctx.reset();
            canvas.requestPaint();
        }

    }
    Item{
        id: punto
        width: 1
        height: width
        opacity: 0.75
        Behavior on x{NumberAnimation{duration: 3000}}
        Behavior on y{NumberAnimation{duration: 3000}}
        Rectangle{
            width: 10
            height: width
            radius: width*0.5
            color: 'red'
            border.width: 2
            border.color: 'white'
            anchors.centerIn: parent
        }
    }



    function load(jsonData){
        canvas.json=jsonData
        /*for(var i=0;i<xAsp.children.length;i++){
            xAsp.children[i].destroy(1)
        }*/
        //console.log(JSON.stringify(jsonData))
        //return
        //if(!jsonData.asps)return

    }
}
