import swisseph as swe
import jdutil
import datetime
import sys, os, json
from subprocess import run, PIPE, Popen
import subprocess

def getJsonRs(h,gmt, lat, lon, gdeg, mdeg, sdeg):
    dia=h.strftime('%d')
    mes=int(h.strftime('%m'))
    anio=h.strftime('%Y')
    hora=h.strftime('%H')
    min=h.strftime('%M')
    proc = subprocess.Popen(['python3', './py/astrologica_swe_search_revsol.py', str(dia), str(mes), str(anio), str(hora), str(min), str(gmt), str(lat), str(lon), str(gdeg), str(mdeg), str(sdeg)], stdout=subprocess.PIPE)
    #proc = subprocess.Popen(['python3', './py/astrologica_swe_search_revsol.py', str(dia), str(mes), str(anio), str(hora), str(min), str(gmt), str(lat), str(lon), str(gdeg), str(mdeg), str(sdeg)], shell=True, stdout=subprocess.PIPE)
    output = proc.stdout.read()
    #print(output)
    return output




fileData=sys.argv[1]
gmt = sys.argv[2]
lat = sys.argv[3]
lon = sys.argv[4]
vg = sys.argv[5]
vm = sys.argv[6]
vs = sys.argv[7]

jsonFechas='{'
indexItem=0
f = open(fileData, "r")
for linea in f:
    #print(linea)
    hora = datetime.datetime.fromtimestamp(int(linea)/1000.0)
    #print(hora)
    if indexItem != 0:
        jsonFechas+=','
    jsonFechas+='"item'+str(indexItem)+'":'
    salida=getJsonRs(hora, gmt, lat, lon, vg, vm, vs)
    j = json.loads(salida)
    o=j["ph"]["h1"]["is"]
    os=j["params"]
    os["is"]=str(o)
    jsonFechas+=str(os)
    #jsonFechas+=str(o)
    indexItem = indexItem + 1
    #print(salida)


f.close()

jsonFechas+='}'

print(jsonFechas)
