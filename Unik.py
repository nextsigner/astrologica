from PySide2.QtCore import QObject, Signal, Slot

@Slot(int)
@Slot(str)
def say_something(stuff):
    print(stuff)

class Unik(QObject):
    def __init__(self):
        # Initialize the PunchingBag as a QObject
        QObject.__init__(self)

    @Slot(str, result=str)
    def getFile(self, f):
        file = open(f, "r")
        datos=file.read()
        #print(datos)
        return datos

