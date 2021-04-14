import QtQuick 2.0

Item {
    id: r
    property string longAppName: 'iconAppNameEmpty'
    property string folderName: 'folderAppNameEmpty'

    Component.onCompleted: {
        let s="#!/usr/bin/env xdg-open\n"
            +"[Desktop Entry]\n"
            +"Name="+r.longAppName+"\n"
            +"Comment=Aplicación para Visualizar simbolos de astrología.\n"
            +"Exec=/usr/local/bin/unik -folder=/home/ns/nsp/uda/"+r.folderName+"\n"
            +"Icon=/home/ns/nsp/uda/"+r.folderName+"/icon.png\n"
            +"Terminal=false\nType=Application"
            //+"Type=Application\n" ;
        let fn='/home/ns/Escritorio/'+r.folderName+'.desktop'
        unik.setFile(fn, s)
    }
}
