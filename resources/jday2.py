import jdutil
import datetime
import sys

dia = sys.argv[1]
mes = sys.argv[2]
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]

#msg1 = "Fecha" + dia + "/" + mes
print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)


d = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
print(jdutil.datetime_to_jd(d))
