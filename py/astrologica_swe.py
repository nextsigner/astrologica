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

#s1=str(os.system(cmd1))
print(type(s1))
print(type(str(s1)))
#print(s1.stdout)
s2=str(s1.stdout).split(sep="\n")
for i in s2:
    print('------------------>' + str(i))
#d = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
#horaLocal = d - datetime.timedelta(hours=int(gmt))
#print(horaLocal)

#dia=horaLocal.strftime('%d')
#mes=horaLocal.strftime('%m')
#anio=horaLocal.strftime('%Y')
#hora=horaLocal.strftime('%H')
#min=horaLocal.strftime('%M')

#print('Tiempo: ' + dia + '/' + mes + '/' + anio + ' ' + hora + ':' + min)


#swe.set_ephe_path('/usr/share/libswe/ephe')
#jd1 = swe.julday(int(anio),int(mes),int(dia), int(hora))
#print(jd1)
#jd = swe.julday(int(anio),int(mes),int(dia), int(hora))
#print(jd)

#np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Proserpina', 57), ('Selena', 56), ('Lilith', 12)]

#index=0
#for i in np:
    #pos=swe.calc_ut(jd1, np[index][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)

    #float armc, float geolat, float obliquity, float objlon, float objlat=0.0, char hsys='P'
    #h=swe.houses(jd, -35.47857, -69.61535, bytes("P", encoding = "utf-8"))
    #print(h[0][9])
    #pos2=swe.house_pos(float(h[0][9]), -35.47857, float(pos[0][1]), -69.61535, 0.0, bytes("P", encoding = "utf-8"))

    #print(str(np[index][0]) + ': ' + str(pos[0][0]) + '\n')
    #print('\n')
    #print(pos)
    #print(pos2)
    #index=index + 1


#h=swe.houses(jd, -35.47857, -69.61535, bytes("P", encoding = "utf-8"))
#for i in h:
    #print(i)
    #print('\n')
#print(h)
#help(swe)
