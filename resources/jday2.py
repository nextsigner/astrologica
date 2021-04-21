import jdutil
import datetime
import sys

print(sys.argv[1:])

d = datetime.datetime(1975,6,20,23)  
print(jdutil.datetime_to_jd(d))
