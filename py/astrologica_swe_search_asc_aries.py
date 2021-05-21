import swisseph as swe
import jdutil
import datetime
import sys
from subprocess import run, PIPE

dia = sys.argv[1]
mes = sys.argv[2]
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]
gmt = sys.argv[6]

lat = sys.argv[7]
lon = sys.argv[8]

#print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)

horaLocal = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
horaLocal = horaLocal - datetime.timedelta(hours=int(gmt))
#print(horaLocal)

#dia=horaLocal.strftime('%d')
#mes=int(horaLocal.strftime('%m'))
#anio=horaLocal.strftime('%Y')
#hora=horaLocal.strftime('%H')
#min=horaLocal.strftime('%M')

#print('Tiempo: ' + dia + '/' + mes + '/' + anio + ' ' + hora + ':' + min)

swe.set_ephe_path('/usr/share/libswe/ephe')

jsonMomentos='{'

enDia1=False
momento='0/0/0000 00:00'
grado=0
#print(str(horaLocal))

for hora in range(24):
    #print('Hora: '+str(hora))
    for minuto in range(60):
        #print('Minuto: '+str(minuto))
        horaLocal  += datetime.timedelta(minutes=1)
        #print(str(d))
        jd1 =jdutil.datetime_to_jd(horaLocal)
        h=swe.houses(jd1, float(lat), float(lon), bytes("P", encoding = "utf-8"))
        if int(h[0][0]) == 0:
            horaFinal = horaLocal + datetime.timedelta(hours=int(gmt))
            momento=str(horaFinal)
            grado=float(h[0][0])
            enDia1=True
            break
        #print(str(h[0][0]))
        #print(str(h[0]))


#horaLocal  += datetime.timedelta(days=1)
#print(str(horaLocal))


if enDia1 == False:
#if 1 == int(str('1')):
    for hora in range(24):
        #print('Hora: '+str(hora))
        for minuto in range(60):
            #print('Minuto: '+str(minuto))
            horaLocal  += datetime.timedelta(minutes=1)
            #print(str(d))
            jd1 =jdutil.datetime_to_jd(horaLocal)
            h=swe.houses(jd1, float(lat), float(lon), bytes("P", encoding = "utf-8"))
            if int(h[0][0]) == 0:
                horaFinal = horaLocal + datetime.timedelta(hours=int(gmt))
                momento=str(horaFinal)
                grado=float(h[0][0])
                break


dia=horaFinal.strftime('%d')
mes=horaFinal.strftime('%m')
anio=horaFinal.strftime('%Y')
hora=horaFinal.strftime('%H')
min=horaFinal.strftime('%M')

jsonMomentos+='"fechas":{'
jsonMomentos+='"d":'+dia+','
jsonMomentos+='"m":'+mes+','
jsonMomentos+='"a":'+anio+','
jsonMomentos+='"h":'+hora+','
jsonMomentos+='"min":'+min+''
jsonMomentos+='}'

for signo in range(12):
    horaFinal = horaFinal + datetime.timedelta(hours=2)
    print(str(horaFinal))
    dia=horaFinal.strftime('%d')
    mes=horaFinal.strftime('%m')
    anio=horaFinal.strftime('%Y')
    hora=horaFinal.strftime('%H')
    min=horaFinal.strftime('%M')

    jsonMomentos+=',"fechas":{'
    jsonMomentos+='"d":'+dia+','
    jsonMomentos+='"m":'+mes+','
    jsonMomentos+='"a":'+anio+','
    jsonMomentos+='"h":'+hora+','
    jsonMomentos+='"min":'+min+''
    jsonMomentos+='}'


jsonMomentos+='}'
jsonMomentos+='}'
print(jsonMomentos)
#print(str(grado))
#help(swe)
