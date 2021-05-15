import swisseph as swe
import datetime
import sys
import os
from subprocess import run, PIPE

def decdeg2dms(dd):
   is_positive = dd >= 0
   dd = abs(dd)
   minutes,seconds = divmod(dd*3600,60)
   degrees,minutes = divmod(minutes,60)
   degrees = degrees if is_positive else -degrees
   return (degrees,minutes,seconds)

def getIndexSign(grado):
    index=0
    g=0.0
    for num in range(12):
        g = g + 30.00
        if g > float(grado):
            break
        index = index + 1
        #print('index sign: ' + str(num))

    return index

def getAsp(g1, g2):
    asp=-1
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 10.00:
        asp=0
    return asp


dia = sys.argv[1]
mes = sys.argv[2]
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]
gmt = sys.argv[6]

lat = sys.argv[7]
lon = sys.argv[8]

if int(gmt) < 0:
        gmtCar='W'
        gmtNum=abs(int(gmt))
else:
        gmtCar='E'
        gmtNum=int(gmt)

if float(lon) < 0:
    lonCar='W'
else:
    lonCar='E'


if float(lat) < 0:
        latCar='S'
else:
        latCar='N'


GMSLat=decdeg2dms(float(lat))
GMSLon=decdeg2dms(float(lon))

#print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)

#Astrolog
#Consulta normal ./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47
#Consultar Aspectos ./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47 -a -A 4

cmd1='~/astrolog/astrolog -qa '+str(int(mes))+' '+str(int(dia))+' '+anio+' '+hora+':'+min+' ' + str(gmtNum) + ''+ gmtCar +' ' +str(int(GMSLon[0])) + ':' +str(int(GMSLon[1])) + '' + lonCar + ' ' +str(int(GMSLat[0])) + ':' +str(int(GMSLat[1])) + '' + latCar + '  -a -A 4'
#print(cmd1)

s1 = run(cmd1, shell=True, stdout=PIPE, universal_newlines=True)

s2=str(s1.stdout).split(sep="\n")

index=0
for i in s2:
    print('------------------>' + str(s2[index]))
    index= index + 1
    #if index > 15:
        #break




getIndexSign
horaLocal = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))

jd = swe.julday(int(anio),int(mes),int(dia), int(hora))
#print(jd)

horaLocal = horaLocal - datetime.timedelta(hours=int(gmt))
#print(horaLocal)

dia=horaLocal.strftime('%d')
mes=horaLocal.strftime('%m')
anio=horaLocal.strftime('%Y')
hora=horaLocal.strftime('%H')
min=horaLocal.strftime('%M')

#print('Tiempo: ' + dia + '/' + mes + '/' + anio + ' ' + hora + ':' + min)


swe.set_ephe_path('/usr/share/libswe/ephe')
#help(swe)

jd1 = swe.julday(int(anio),int(mes),int(dia), int(hora))
#print(jd1)


#Este falla, dá el Sol porque falta averiguar el flag
posAsc=swe.calc(jd1, 0, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
#print(posAsc)


np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Proserpina', 57), ('Selena', 56), ('Lilith', 12)]

#La oblicuidad de calcula con ipl = SE_ECL_NUT = -1 en SWE pero en swisseph ECL_NUT = -1
posObli=swe.calc(jd1, -1, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
oblicuidad=posObli[0][0]
#print('Oblicuidad: ' + str(posObli[0][0]))

#Se calculan casas previamente para calcular en cada cuerpo con swe.house_pos(...)
h=swe.houses(jd1, float(lat), float(lon), bytes("P", encoding = "utf-8"))

#Comienza JSON Bodies
tuplaPosBodies=()
jsonBodies='"pc":{\n'
index=0
for i in np:
    pos=swe.calc_ut(jd1, np[index][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
    tuplaPosBodies+=tuple([pos[0][0]])
    #print(pos)
    gObj=float(pos[0][0])
    if index == 11:
        gNN=float(tuplaPosBodies[index - 1])
        if gNN < 180:
            gNS= 360.00 - gNN
        else:
            gNS=gNN - 180.00

        print('Planeta: ' +np[index][0] + ' casa ' + str(posHouse))
        print('Grado de Nodo Norte: '+str(gNN))
        print('Grado de Nodo Sur: '+str(gNS))
        gObj=gNS

    indexSign=getIndexSign(gObj)
    td=decdeg2dms(gObj)
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    rsgdeg=gdeg - ( indexSign * 30 )
    jsonBodies+='"c' + str(index) +'": {\n'
    jsonBodies+='   "nom":"' + str(np[index][0]) + '"\n'
    jsonBodies+='   "is":' + str(indexSign)+', \n'
    jsonBodies+='   "gdec":' + str(gObj)+',\n'
    jsonBodies+='   "gdeg":' + str(gdeg)+',\n'
    jsonBodies+='   "rsgdeg":' + str(rsgdeg)+',\n'
    jsonBodies+='   "mdeg":' + str(mdeg)+',\n'
    jsonBodies+='   "sdeg":' + str(sdeg)+',\n'
    posHouse=swe.house_pos(h[0][9],float(lat), oblicuidad, gObj, 0.0, bytes("P", encoding = "utf-8"))



    jsonBodies+='   "ih":' + str(int(posHouse))+',\n'
    jsonBodies+='   "dh":' + str(posHouse)+'\n'
    jsonBodies+='   }\n'
    index=index + 1

jsonBodies+='}'

#print(tuplaPosBodies)
tuplaArr=(())
arr1=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
arr2=(0,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
arr3=(0,1,3,4,5,6,7,8,9,10,11,12,13,14,15)
arr4=(0,1,2,4,5,6,7,8,9,10,11,12,13,14,15)
arr5=(0,1,2,3,5,6,7,8,9,10,11,12,13,14,15)
arr6=(0,1,2,3,4,6,7,8,9,10,11,12,13,14,15)
arr7=(0,1,2,3,4,5,7,8,9,10,11,12,13,14,15)
arr8=(0,1,2,3,4,5,6,8,9,10,11,12,13,14,15)
arr9=(0,1,2,3,4,5,6,7,9,10,11,12,13,14,15)
arr10=(0,1,2,3,4,5,6,7,8,10,11,12,13,14,15)
arr11=(0,1,2,3,4,5,6,7,8,9,11,12,13,14,15)
arr12=(0,1,2,3,4,5,6,7,8,9,10,12,13,14,15)
arr13=(0,1,2,3,4,5,6,7,8,9,10,11,13,14,15)
arr14=(0,1,2,3,4,5,6,7,8,9,10,11,12,14,15)
arr15=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,15)
arr16=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14)
tuplaArr=((arr1),(arr2),(arr3),(arr4),(arr5),(arr6),(arr7),(arr8),(arr9),(arr10),(arr11),(arr12),(arr13),(arr14),(arr15),(arr16))
#print(tuplaArr)
index=0
for i in tuplaPosBodies:
    print('i:' + str(i))
    for num in range(15):
        #print('Comp: ' + str(np[index][0]) + ' con ' + str(np[tuplaArr[index][num]][0]))
        g1=float(tuplaPosBodies[index])
        g2=float(tuplaPosBodies[tuplaArr[index][num]])
        #print('g1: '+str(g1) + ' g2: ' + str(g2))
        asp=getAsp(g1, g2)
        #print(asp)
        #print('Comp:' + np[index][0] + ' con '
    index = index + 1


#Comienza JSON Houses
jsonHouses='"ph":{\n'
numHouse=1
#print('ARMC:' + str(h[0][9]))

for i in h[0]:
    td=decdeg2dms(i)
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    index=getIndexSign(float(i))
    jsonHouses+='"h' + str(numHouse) + '": {\n'
    jsonHouses+='   "is":' + str(index)+', \n'
    jsonHouses+='   "gdec":' + str(i)+',\n'
    jsonHouses+='   "gdeg":' + str(gdeg)+',\n'
    jsonHouses+='   "mdeg":' + str(mdeg)+',\n'
    jsonHouses+='   "sdeg":' + str(sdeg)+'\n'
    if numHouse != 12:
        jsonHouses+='"},\n'
    else:
        jsonHouses+='}\n'
    numHouse = numHouse + 1

print(jsonBodies)
print(jsonHouses)

#mp=swe.deg_midp(0.0, 90.0)
#print('MP: '+str(mp))
#difDeg=swe.difdegn(0.00, 180.00)
#print('difDeg: '+str(difDeg))

