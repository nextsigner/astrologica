import QtQuick 2.0

Item{
    id: r
    property var cAs: r
    property int fs: app.fs*0.75

    property var objSignsNames: ['ari', 'tau', 'gem', 'cnc', 'leo', 'vir', 'lib', 'sco', 'sgr', 'cap', 'aqr', 'psc']
    property var objSigns: [0,0,0,0,0,0,0,0,0,0,0,0]

    signal cnLoaded(string nombre, string dia, string mes, string anio, string hora, string minuto, string lon, string lat, string ciudad)
    signal doubleClick
    signal posChanged(int px, int py)

    onCAsChanged: {
        //if(cAs!==r){
        //xTip.visible=cAs!==r
        //}
        //labelText.text =cAs!==r?'<b style="font-size:'+parseInt(labelText.font.pixelSize*1.35)+'px;">'+app.planetas[cAs.numAstro]+'</b><br /><b>'+app.signos[cAs.objData.ns]+'</b><br /><b>°'+cAs.objData.g+' \''+cAs.objData.m+'</b><br /><b>Casa '+cAs.objData.h+'</b>':'Mercurio'
        //xTip.anchors.bottom=cAs.top
        //xTip.anchors.bottomMargin=r.fs*2
        //xTip.anchors.horizontalCenter=cAs.horizontalCenter
        //tResetTip.restart()
    }
    XAs{id:xSol;fs:r.fs;astro:'sun'; numAstro: 0}
    XAs{id:xLuna;fs:r.fs;astro:'moon'; numAstro: 1}
    XAs{id:xMercurio;fs:r.fs;astro:'mercury'; numAstro: 2}
    XAs{id:xVenus;fs:r.fs;astro:'venus'; numAstro: 3}
    XAs{id:xMarte;fs:r.fs;astro:'mars'; numAstro: 4}
    XAs{id:xJupiter;fs:r.fs;astro:'jupiter'; numAstro: 5}
    XAs{id:xSaturno;fs:r.fs;astro:'saturn'; numAstro: 6}
    XAs{id:xUrano;fs:r.fs;astro:'uranus'; numAstro: 7}
    XAs{id:xNeptuno;fs:r.fs;astro:'neptune'; numAstro: 8}
    XAs{id:xPluton;fs:r.fs;astro:'pluto'; numAstro: 9}
    XAs{id:xQuiron;fs:r.fs;astro:'hiron'; numAstro: 10}
    XAs{id:xProserpina;fs:r.fs;astro:'proserpina'; numAstro: 11}
    XAs{id:xSelena;fs:r.fs;astro:'selena'; numAstro: 12}
    XAs{id:xLilith;fs:r.fs;astro:'lilith'; numAstro: 13}
    XAs{id:xNodoPS;fs:r.fs;astro:'ns'; numAstro: 14}
    XAs{id:xNodoPN;fs:r.fs;astro:'nn'; numAstro: 15}
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
        let jo
        let o

        jo=json.pc.c0
        xSol.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[objSignsNames.indexOf(jo.is)]
        o.ns=objSignsNames.indexOf(jo.is)
        o.g=jo.gdeg
        o.m=jo.mdeg
        o.h=jo.h
        xSol.objData=o
        objSigns[objSignsNames.indexOf(jo.is)]++

        jo=json.pc.c1
        xLuna.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xLuna.objData=o
        objSigns[jo.is]++

        jo=json.pc.c2
        xMercurio.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xMercurio.objData=o
        objSigns[jo.is]++

        jo=json.pc.c3
        xVenus.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xVenus.objData=o
        objSigns[jo.is]++

        jo=json.pc.c4
        xMarte.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xMarte.objData=o
        objSigns[jo.is]++

        jo=json.pc.c5
        xJupiter.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xJupiter.objData=o
        objSigns[jo.is]++


        jo=json.pc.c6
        xSaturno.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xSaturno.objData=o
        objSigns[jo.is]++

        jo=json.pc.c7
        xUrano.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xUrano.objData=o
        objSigns[jo.is]++

        jo=json.pc.c8
        xNeptuno.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xNeptuno.objData=o
        objSigns[jo.is]++

        jo=json.pc.c9
        xPluton.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xPluton.objData=o
        objSigns[jo.is]++

        jo=json.pc.c10
        xNodoPN.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xNodoPN.objData=o
        objSigns[jo.is]++

        jo=json.pc.c11
        xNodoPS.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xNodoPS.objData=o
        objSigns[jo.is]++

        jo=json.pc.c12
        xQuiron.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xQuiron.objData=o
        objSigns[jo.is]++

        jo=json.pc.c13
        xSelena.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xSelena.objData=o
        objSigns[jo.is]++

        jo=json.pc.c14
        xProserpina.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xProserpina.objData=o
        objSigns[jo.is]++

        jo=json.pc.c15
        xLilith.rotation=signCircle.rotation-jo.gdeg
        o={}
        o.p=objSigns[jo.is]
        o.ns=jo.is
        o.g=jo.g
        o.m=jo.m
        o.h=jo.h
        xLilith.objData=o
        objSigns[jo.is]++
    }
}
