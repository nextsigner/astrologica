from PySide2.QtCore import QObject, Signal, Slot

@Slot(int)
@Slot(str)
def say_something(stuff):
    print(stuff)

class Unik(QObject):
    ''' Represents a punching bag; when you punch it, it
        emits a signal that indicates that it was punched. '''
    punched = Signal()

    def __init__(self):
        # Initialize the PunchingBag as a QObject
        QObject.__init__(self)

    @Slot(float, result=int)
    def getFloatReturnInt(self, f):
        return int(f)
    @Slot(str, result=str)
    def getFile(self, f):
        file = open(f, "r")
        datos=file.read()
        return datos

     #def punch(self):
        #''' Punch the bag '''
        #self.punched.emit()
