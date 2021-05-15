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
cmd1='~/astrolog/astrolog -qa '+str(int(mes))+' '+str(int(dia))+' '+anio+' '+hora+':'+min+' ' + str(gmtNum) + ''+ gmtCar +' ' +str(int(GMSLon[0])) + ':' +str(int(GMSLon[1])) + '' + lonCar + ' ' +str(int(GMSLat[0])) + ':' +str(int(GMSLat[1])) + '' + latCar + ''
print(cmd1)

s1 = run(cmd1, shell=True, stdout=PIPE, universal_newlines=True)

s2=str(s1.stdout).split(sep="\n")

index=3
for i in s2:
    #print('------------------>' + str(s2[index]))
    index= index + 1
    if index > 15:
        break



#./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47 -a -A 4

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


#La oblicuidad de calcula con ipl = SE_ECL_NUT = -1 en SWE pero en swisseph ECL_NUT = -1
posAsc=swe.calc(jd1, 0, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
print(posAsc)


np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Proserpina', 57), ('Selena', 56), ('Lilith', 12)]

posObli=swe.calc(jd1, -1, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
oblicuidad=posObli[0][0]
print('Oblicuidad: ' + str(posObli[0][0]))

h=swe.houses(jd1, -35.47857, -69.61535, bytes("P", encoding = "utf-8"))

jsonBodies='"pc":{\n'
index=0
for i in np:
    pos=swe.calc_ut(jd1, np[index][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
    indexSign=getIndexSign(float(pos[0][0]))
    td=decdeg2dms(float(pos[0][0]))
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    rsgdeg=gdeg - ( indexSign * 30 )
    jsonBodies+='"c' + str(index) +'": {\n'
    jsonBodies+='   "nom":"' + str(np[index][0]) + '"\n'
    jsonBodies+='   "is":' + str(indexSign)+', \n'
    jsonBodies+='   "gdec":' + str(pos[0][0])+',\n'
    jsonBodies+='   "gdeg":' + str(gdeg)+',\n'
    jsonBodies+='   "rsgdeg":' + str(rsgdeg)+',\n'
    jsonBodies+='   "mdeg":' + str(mdeg)+',\n'
    jsonBodies+='   "sdeg":' + str(sdeg)+'\n'
    jsonBodies+='   }\n'
    #Args: float armc, float geolat, float obliquity, float objlon, float objlat=0.0, char hsys='P'
    #posHouse=swe.house_pos(float(h[0][9]),-35.47857, float(oblicuidad), 0.0, 0.0, bytes("P", encoding = "utf-8")
    posHouse=swe.house_pos(h[0][9],-35.47857, oblicuidad, pos[0][0], 0.0, bytes("P", encoding = "utf-8"))
    print('Planeta: ' +np[index][0] + ' casa ' + str(posHouse))
    index=index + 1

jsonBodies+='}'
print(jsonBodies)




jsonHouses='"ph":{\n'
numHouse=1
print('ARMC:' + str(h[0][9]))



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

print(jsonHouses)




