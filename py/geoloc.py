import sys
from geopy.geocoders import Nominatim

lugar = sys.argv[1]
geolocator = Nominatim(user_agent='myapplication')
location = geolocator.geocode(lugar)
#print(location.address)
jsonCoords='{'
jsonCoords+='"coords":{'
jsonCoords+='"lat": '+str(location.latitude)+','
jsonCoords+='"lon": '+str(location.longitude)
jsonCoords+='}'
jsonCoords+='}'
print(jsonCoords)
