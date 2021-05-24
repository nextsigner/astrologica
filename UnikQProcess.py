from PySide2.QtCore import Property, QCoreApplication, QObject, Signal, Slot
import subprocess

class UnikQProcess(QObject):
    logDataChanged = Signal()
    #logData=''
    def __init__(self, parent=None):
        super().__init__(parent)
        self._logData = ''


    @Property(str)
    def logData(self):
            return self._logData
    @Signal
    def logDataChanged(self):
        print('Signal lodData!')

    @Slot(result=str)
    def getLogData(self):
        return str(self._logData)
    @Slot(str)
    def setLogData(self, ld):
        self._logData=str(ld)
        #print('--->:::-->'+str(logData))
        self.logDataChanged.emit()

    @Slot(str)
    def run(self, cmd):
        print('Cmd: ' + cmd)
        #command = subprocess.run(['ls', '-l'], capture_output=True)
        listaCmd=cmd.split(sep=' ')
        #print(listaCmd)
        command = subprocess.run(listaCmd, capture_output=True)
        #print(command.stdout)
        self.setLogData(command.stdout)

    logData = Property(str, getLogData, setLogData, notify=logDataChanged)
    #punched.connect(setLogData)


#speak = Signal()
    #def __init__(self):
        #super(Communicate, self).__init__()
        #self.speak.connect(self.say_hello)

        #def speaking_method(self):
            #self.speak.emit()

        #def say_hello(self):
            #print("Hello")
