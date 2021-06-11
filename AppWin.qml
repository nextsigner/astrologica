import QtQuick 2.12
import QtQuick.Controls 2.12


ApplicationWindow {
    id: r
    property alias ssp: xPlanets.ssp
    XPlanets{id: xPlanets}
    Shortcut{
        sequence: 'Ctrl+Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.ctrlDown()
                return
            }
            xDataBar.state=xDataBar.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.ctrlUp()
                return
            }
            if(app.mod===0){
                app.mod=1
            }else{
                app.mod=0
                xFlecha.x=0-app.fs*3
                xFlecha.y=0-app.fs*3
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+Space'
        onActivated: {
            sweg.nextState()
        }
    }
    Shortcut{
        sequence: 'Ctrl+0'
        onActivated: {
            panelDataBodies.currentIndex=-1
            //app.lock=!app.lock
        }
    }
    Shortcut{
        sequence: 'Enter'
        onActivated: {
            if(panelNewVNA.state==='show'){
                panelNewVNA.enter()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.visible=false
                return
            }
            if(panelFileLoader.state==='show'){
                panelFileLoader.state='hide'
                return
            }
            if(panelDataBodies.state==='show'){
                panelDataBodies.state='hide'
                return
            }
            if(panelNewVNA.state==='show'){
                panelNewVNA.state='hide'
                return
            }
            if(panelControlsSign.state==='show'){
                panelControlsSign.state='hide'
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.up()
                return
            }
            if(panelFileLoader.state==='show'){
                if(panelFileLoader.currentIndex>0){
                    panelFileLoader.currentIndex--
                }else{
                    panelFileLoader.currentIndex=panelFileLoader.listModel.count-1
                }
                return
            }
            if(panelDataBodies.enabled){
                if(currentSignIndex>0){
                    currentSignIndex--
                }else{
                    currentSignIndex=12
                }
                return
            }
            if(currentPlanetIndex>0){
                currentPlanetIndex--
            }else{
                currentPlanetIndex=16
            }
            //xAreaInteractiva.back()
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.down()
                return
            }
            if(panelFileLoader.state==='show'){
                if(panelFileLoader.currentIndex<panelFileLoader.listModel.count){
                    panelFileLoader.currentIndex++
                }else{
                    panelFileLoader.currentIndex=0
                }
                return
            }
            if(panelDataBodies.enabled){
                if(currentSignIndex<12){
                    currentSignIndex++
                }else{
                    currentSignIndex=0
                }
                return
            }
            if(currentPlanetIndex<16){
                currentPlanetIndex++
            }else{
                currentPlanetIndex=0
            }
            //xAreaInteractiva.next()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.left()
                return
            }
            xAreaInteractiva.acercarAlCentro()
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.right()
                return
            }
            xAreaInteractiva.acercarAlBorde()
        }
    }
    Shortcut{
        sequence: 'Ctrl+f'
        onActivated: {
            panelFileLoader.state=panelFileLoader.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+c'
        onActivated: {
            panelCmd.state=panelCmd.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+i'
        onActivated: {
            panelDataBodies.state=panelDataBodies.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+e'
        onActivated: {
            sweg.expand=!sweg.expand
        }
    }
    Shortcut{
        sequence: 'Ctrl+n'
        onActivated: {
            panelNewVNA.state=panelNewVNA.state==='show'?'hide':'show'
        }
    }
    Shortcut{
        sequence: 'Ctrl+r'
        onActivated: {
            if(!xFormRS.visible){
                xFormRS.alNom=app.currentNom
                xFormRS.alFecha=app.currentFecha
                xFormRS.grado=app.currentGradoSolar
                Qt.ShiftModifierxFormRS.minuto=app.currentMinutoSolar
                xFormRS.segundo=app.currentSegundoSolar
                xFormRS.lon=app.currentLon
                xFormRS.lat=app.currentLat
            }
            xFormRS.visible=!xFormZS.visible
        }
    }
    Shortcut{
        sequence: 'Ctrl+o'
        onActivated: {
            //img.y+=4
            showIWFILES()
        }
    }
    Shortcut{
        sequence: 'Ctrl+s'
        onActivated: {
            //img.y+=4
            showSABIANOS()
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Down'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.zoomDown()
                return
            }
            //signCircle.subir()
            sweg.objSignsCircle.rotarSegundos(0)
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Up'
        onActivated: {
            if(xSabianos.visible){
                xSabianos.zoomUp()
                return
            }
            //signCircle.bajar()
            sweg.objSignsCircle.rotarSegundos(1)
        }
    }
    Shortcut{
        sequence: 'Ctrl++'
        onActivated: {
            sweg.width+=app.fs
        }
    }
    Shortcut{
        sequence: 'Ctrl+-'
        onActivated: {
            sweg.width-=app.fs
        }
    }
}
