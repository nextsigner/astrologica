from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl
from PySide2.QtQml import qmlRegisterType
from pathlib import Path
from UnikQProcess import UnikQProcess
from Unik import Unik
mainfilepath = Path(Path(__file__).resolve()).parent / "main.qml"
app = QApplication([])
url = QUrl(str(mainfilepath))
engine = QQmlApplicationEngine()
qmlRegisterType(UnikQProcess, "unik.UnikQProcess", 1, 0, "UnikQProcess")
unik = Unik()
context = engine.rootContext()
context.setContextProperty("unik", unik)
engine.load(url)
app.exec_()
