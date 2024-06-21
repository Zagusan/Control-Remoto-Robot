# This Python file uses the following encoding: utf-8
import simplepyble as simpleble
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QObject, Slot, Signal



class Frontend(QObject):

    adapter = None

    enableSearchButton = Signal()
    searchStopped = Signal()
    changeBluetooth = Signal(bool)

    def __init__(self):
        QObject.__init__(self)

    @Slot()
    def qml_bluetooth_enabled(self):
        print(simpleble.Adapter.bluetooth_enabled())
        return simpleble.Adapter.bluetooth_enabled()

    @Slot()
    def change_bluetooth(self):
        self.changeBluetooth.emit(simpleble.Adapter.bluetooth_enabled())

    @Slot()
    def bt_start_search(self):
        print("Beginning scan")
        self.adapter.scan_start()
        self.adapter.scan_for(5000)

    @Slot()
    def bt_search_stopped(self):
        print("Scan stopped")
        self.searchStopped.emit()

if __name__ == "__main__":
    app = QGuiApplication()
    view = QQuickView()
    frontend = Frontend()

    view.rootContext().setContextProperty("backend", frontend)
    view.setSource("main.qml")
    view.setResizeMode(QQuickView.SizeRootObjectToView)

    try:
        frontend.adapter = simpleble.Adapter.get_adapters()[0]
        print("Selected " + frontend.adapter.identifier() + " (" + frontend.adapter.address() + ")" + " as the Bluetooth adapter")
        frontend.enableSearchButton.emit()

        frontend.adapter.set_callback_on_scan_stop(frontend.bt_search_stopped)
    except IndexError:
        print("No Bluetooth adapters found")

    frontend.change_bluetooth()

    view.show()

    app.exec()
    del view
