#!/bin/bash
echo "Iniciando busqueda de grado de revolución solar..."
LON=$1
LAT=$2
GRADOSOL=$3
MINUTOSOL=$4
SEGUNDOSOL=$5

PDIA=$6
PMES=$7
PANIO=$8
echo "Buscando grado del sol °"$GRADOSOL" '"$MINUTOSOL" ''"$SEGUNDOSOL
echo "Longitud: "$LON" Latitud:"$LAT
echo "Fecha: "$PDIA"/"$PMES"/"$PANIO

FDIA=""
FMES=""
FANIO=""


function isDigit(){
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
    return 1
else
    return 0
fi
}

function is(){
    IFS=$'\n'
    for i in "$1" ;
    do
    p1=$(echo "$i" | grep 'Sun : ')
    #echo "p1:--->"$p1
    p2=$(echo $p1 | cut -f2 -d':')
    #echo "p2:--->"$p2
    p3=$(echo $p2 | cut -f1 -d'+')
    p4=$(echo $p3 | cut -f1 -d'-')
    p5=${p4// /}
    p6="${p5:1:1}"

    SIGNODETECTADO=""
    GRADODETECTADO=""
    MINUTODETECTADO=""

    #Comineza comparación para saber si el grado es de 2 digitos
    ISGRADO2DIGITO=false
    if( isDigit $p6)
    then
        #echo "SI 2D"
        GRADODETECTADO="${p5:0:2}"
        MINUTODETECTADO="${p5:5:6}"
        SIGNODETECTADO="${p5:2:3}"
    else
        #echo "NO 2D"
        GRADODETECTADO="${p5:0:1}"
        MINUTODETECTADO="${p5:4:5}"
        SIGNODETECTADO="${p5:1:3}"
    fi

    #echo "GRADODETECTADO: "$GRADODETECTADO
    #echo "MINUTODETECTADO: "$MINUTODETECTADO
    #echo "SIGNODETECTADO: "$SIGNODETECTADO

    #echo "EEE#####################---->p6:["$p6"]"
    #echo "EEE#####################---->p5: "$p5
    if [[ $GRADODETECTADO =~ "$GRADOSOL" && $MINUTODETECTADO =~ "$MINUTOSOL" ]]; then
        echo "EN GRADOSOL: "$GRADODETECTADO" MINUTOSOL: "$MINUTODETECTADO
        echo "$GRADODETECTADO"
    fi
    done
echo ""
}

getGMS(){
    echo "getGMS..."
    FDIA=$1
    FMES=$2
    FANIO=$3
    horas=''
    for (( var=0; var<=23; var++ )) #poner en 23
    do
    v1=0
    if(($var<10))
    then
    horas=$horas' 0'$var
    else
    horas=$horas' '$var
    fi
    done
    horasComp=''
    for hora in $horas
    do
    for (( min=0; min<=59; min+=1 ))
    do
    if(($min<10))
    then
    horasComp=$hora':0'$min
    else
    horasComp=$hora':'$min
    fi
    echo $horasComp
    #/home/ns/astrolog/astrolog -qa 2 1 2020 $horasComp 0 0.0 0.0
    datos=$(/home/ns/nsp/uda/astromes/astrolog/astrolog -qa $2 $1 $3 $horasComp 0 $LON $LAT>&1)
    #echo "$datos"
    SUN=$(is "$datos")
    echo "SUN=$SUN"
    #ASC=$(is "$datos")
    #echo "RET: $ASC"
    if [[ $SUN != "" ]]; then
    #echo "ARIES-->#####################---->"$p1
    echo "$FDIA $FMES $FANIO $horasComp"
    break
    fi
    done  
    done
}
getGMS $PDIA $PMES $PANIO
#getGMS 2 22 2021
exit;
