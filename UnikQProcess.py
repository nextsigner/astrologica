# This Python file uses the following encoding: utf-8
#from PySide6 import QtWidgets
#from PySide6 import QtQuick
#from PySide6.QtQuick import QQuickItem

import sys

from PySide2.QtCore import Property, QCoreApplication, QObject, QProcess, QUrl, Signal, Slot
from PySide2.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine

class UnikQProcess(QProcess):
    def __init__(self, parent=None):
        super().__init__(parent)

        # Initialise the value of the properties.
        self._name = ''
        self._shoeSize = 0

        @Slot(str)
        def run(cmd):
            print('Cmd: ' + cmd)


