function setFs() {
    let w = Screen.width
    let h = Screen.height
    if(w===1920 && h === 1080){
        app.fs = w*0.031
    }
    if(w===1680 && h === 1050){
        app.fs = w*0.036
    }
    if(w===1400 && h === 1050){
        app.fs = w*0.041
    }
    if(w===1600 && h === 900){
        app.fs = w*0.031
    }
    if(w===1280 && h === 1024){
        app.fs = w*0.045
    }
    if(w===1440 && h === 900){
        app.fs = w*0.035
    }
    if(w===1280 && h === 800){
        app.fs = w*0.035
    }
    if(w===1152 && h === 864){
        app.fs = w*0.042
    }
    if(w===1280 && h === 720){
        app.fs = w*0.03
    }
}
