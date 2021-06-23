import QtQuick 2.0

Rectangle {
    id: r
    width: cellWidth*15
    height: cellWidth*15
    color: 'transparent'
    antialiasing: true
    property int cellWidth: app.fs*0.4
    Row{
        id: row
        Repeater{
            model: 15
            CellRowAsp{planet: index;cellWidth: r.cellWidth; objectName: 'cellRowAsp_'+index}
        }
    }
    MouseArea{
        anchors.fill: r
        //onClicked: clear()
    }
    function clear(){
        for(var i=0;i<15;i++){
            let column=row.children[i]
            column.clear()
        }
    }
    function setAsp2(c1, c2, ia){
        let column=row.children[c2]
        console.log('column.objectName: '+column.objectName)
        let cellRow=column.col.children[c1]
        console.log('cellRow.objectName: '+cellRow.objectName)
        cellRow.indexAsp=ia
        //cellRow.opacity=1.0
    }
    function setAsp(c1, c2, ia){
        setAsp2(c1,c2,ia)
        setAsp2(c2,c1,ia)
    }
    function load(jsonData){
        clear()
        if(!jsonData.asps)return
        let asp=jsonData.asps
        for(var i=0;i<Object.keys(asp).length;i++){
            if(asp['asp'+parseInt(i +1)]){
                let a=asp['asp'+parseInt(i +1)]
                //console.log('Asp: '+'asp'+parseInt(i +1))
                //let comp=Qt.createComponent('XAsp.qml')
                //let obj=comp.createObject(xAsp, {c1:a.c1, c2:a.c2, ic1:a.ic1, ic2:a.ic2, tipo:a.ia, indexAsp: i})
                setAsp(a.ic1, a.ic2, a.ia)
            }
        }
    }
}
