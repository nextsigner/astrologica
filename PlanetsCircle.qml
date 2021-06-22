import QtQuick 2.0

Item{
    id: r
    property bool expand: false
    property var cAs: r
    property int planetSize: sweg.fs*0.75

    property int totalPosX: 0

    property var objSignsNames: ['ari', 'tau', 'gem', 'cnc', 'leo', 'vir', 'lib', 'sco', 'sgr', 'cap', 'aqr', 'psc']
    property var objSigns: [0,0,0,0,0,0,0,0,0,0,0,0]

    signal cnLoaded(string nombre, string dia, string mes, string anio, string hora, string minuto, string lon, string lat, string ciudad)
    signal doubleClick
    signal posChanged(int px, int py)
    state: sweg.state
    states: [
        State {
            name: sweg.aStates[0]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*2.5-sweg.fs
            }
        },
        State {
            name: sweg.aStates[1]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*6-sweg.fs
            }
        },
        State {
            name: sweg.aStates[2]
            PropertyChanges {
                target: r
                width: sweg.width-sweg.fs*2-sweg.fs
            }
        }
    ]   
    //np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Proserpina', 57), ('Selena', 56), ('Lilith', 12)]
    XAs{id:xSol;fs:r.planetSize;astro:'sun'; numAstro: 0}
    XAs{id:xLuna;fs:r.planetSize;astro:'moon'; numAstro: 1}
    XAs{id:xMercurio;fs:r.planetSize;astro:'mercury'; numAstro: 2}
    XAs{id:xVenus;fs:r.planetSize;astro:'venus'; numAstro: 3}
    XAs{id:xMarte;fs:r.planetSize;astro:'mars'; numAstro: 4}
    XAs{id:xJupiter;fs:r.planetSize;astro:'jupiter'; numAstro: 5}
    XAs{id:xSaturno;fs:r.planetSize;astro:'saturn'; numAstro: 6}
    XAs{id:xUrano;fs:r.planetSize;astro:'uranus'; numAstro: 7}
    XAs{id:xNeptuno;fs:r.planetSize;astro:'neptune'; numAstro: 8}
    XAs{id:xPluton;fs:r.planetSize;astro:'pluto'; numAstro: 9}
    XAs{id:xNodoPN;fs:r.planetSize;astro:'nn'; numAstro: 10}
    XAs{id:xNodoPS;fs:r.planetSize;astro:'ns'; numAstro: 11}
    XAs{id:xQuiron;fs:r.planetSize;astro:'hiron'; numAstro: 12}
    XAs{id:xSelena;fs:r.planetSize;astro:'selena'; numAstro: 14}
    XAs{id:xLilith;fs:r.planetSize;astro:'lilith'; numAstro: 15}
    function pressed(o){
        unik.speak(''+app.planetas[o.numAstro]+' en '+app.signos[o.objData.ns]+' en el grado '+o.objData.g+' en la casa '+o.objData.h)
    }
    function doublePressed(o){
        unik.speak(" ")
        xConfirmSearchVideoBy.cuerpo=app.planetas[o.numAstro]
        xConfirmSearchVideoBy.signo=app.signos[o.objData.ns]
        xConfirmSearchVideoBy.casa=o.objData.h
        let link=r.getYtVideoUrl(xConfirmSearchVideoBy.cuerpo, xConfirmSearchVideoBy.casa)
        console.log('link: '+link)
        xConfirmSearchVideoBy.url1=link
        xConfirmSearchVideoBy.visible=true
    }
    function loadJson(json){
        r.totalPosX=-1
        r.objSigns = [0,0,0,0,0,0,0,0,0,0,0,0]
        let jo
        let o
        //if(app.sspEnabled)app.ip.children[0].ssp.lm.clear()
        for(var i=0;i<15;i++){
            var objAs=r.children[i]
            objAs.numAstro=i
            jo=json.pc['c'+i]
            objAs.rotation=signCircle.rot-jo.gdeg
            o={}
            o.p=objSigns[jo.is]
            if(r.totalPosX<o.p){
                r.totalPosX=o.p
            }
            if(i<10){
                //if(app.sspEnabled)app.ip.children[0].ssp.add(app.planetas[i], "images/"+app.planetasRes[i]+".png",i)
            }
            o.ns=objSignsNames.indexOf(jo.is)
            o.ih=jo.ih
            o.rsg=jo.rsgdeg
            o.g=jo.gdeg
            o.m=jo.mdeg
            o.h=jo.h
            objAs.is=jo.is
            objAs.objData=o
            objSigns[jo.is]++
            if(i===0){
                app.currentAbsolutoGradoSolar=jo.rsgdeg
                app.currentGradoSolar=jo.gdeg
                app.currentMinutoSolar=jo.mdeg
                app.currentSegundoSolar=jo.sdeg
            }
        }        
    }
}
