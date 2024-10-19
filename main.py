# This Python file uses the following encoding: utf-8
import simplepyble as simpleble
from math import sqrt, pow
from concurrent.futures import ThreadPoolExecutor
from PySide6.QtGui import QGuiApplication, QMouseEvent
from PySide6.QtQuick import QQuickView, QQuickItem
from PySide6.QtCore import QObject, Slot, Signal
from PySide6.QtQml import QQmlComponent, QQmlEngine

# Permite ejecutar código en otro hilo
executor = ThreadPoolExecutor()

class Bluetooth(QObject):

	searchStopped = Signal(list)

	def __init__(self):
		QObject.__init__(self)

		try:
			self.adapter = simpleble.Adapter.get_adapters()[0]
			print("Selected " + self.adapter.identifier() + " (" + self.adapter.address() + ")" + " as the Bluetooth adapter")

			self.adapter.set_callback_on_scan_stop(self._search_stopped)
		except IndexError:
			print("No Bluetooth adapters found")
			raise IndexError
	
	def scan(self):
		print("Scan Started")
		executor.submit(self.adapter.scan_for, 5000)

	# Función privada de uso interno
	def _search_stopped(self):
		print("Scan Stopped")

		# Obtiene los dispositivos que se encontraron
		peripherals = self.adapter.scan_get_results()
		print(str(len(peripherals)) + " devices found")
		self.searchStopped.emit(peripherals)

class UIShortcuts:
	def __init__(self, root: QQuickItem):
		self.stackLayout: QQuickItem = root.findChild(QQuickItem, "stackLayout")
		self.searchButton: QQuickItem = root.findChild(QQuickItem, "search")
		self.searchIndicator: QQuickItem = root.findChild(QQuickItem, "searchIndicator")
		self.controlsButton: QQuickItem = root.findChild(QQuickItem, "controls")
		self.backButton: QQuickItem = root.findChild(QQuickItem, "back")
		self.devicesColumn: QQuickItem = root.findChild(QQuickItem, "devices")
		self.joystick: QQuickItem = root.findChild(QQuickItem, "joystick")
		self.controlBG: QQuickItem = root.findChild(QQuickItem, "controlBG")

class UITemplates:
	def __init__(self, engine: QQmlEngine):
		self.peripheralButton = QQmlComponent(engine, "peripheralButton.qml")
		self.mouseArea = QQmlComponent(engine, "mouseArea.qml")

	def new_button(self, parent: QQuickItem):
		button: QQuickItem = self.peripheralButton.create()
		button.setParentItem(parent)
		return button
	
	def new_mouse_area(self, parent: QQuickItem):
		area: QQuickItem = self.mouseArea.create()
		area.setParentItem(parent)
		return area

# Clase para modificar la interfaz de usuario
class UIBridge(QObject):
	def __init__(self):
		QObject.__init__(self)

		self.app = QGuiApplication()
		self.view = QQuickView()

		# Hace que las funciones de UIBridge se puedan usar desde el QML
		self.view.rootContext().setContextProperty("backend", self)

		self.view.setSource("main.ui.qml")
		self.view.setResizeMode(QQuickView.SizeRootObjectToView)

		self.root = self.view.rootObject()
		
		self.shortcuts = UIShortcuts(self.root)
		self.templates = UITemplates(self.view.engine())

		self.shortcuts.mouseArea = self.templates.new_mouse_area(self.shortcuts.joystick)

		self.view.show()

	def change_bluetooth(self):
		bluetoothAvailable: QQuickItem = self.root.findChild(QQuickItem, "bluetoothAvailable")
		bluetoothAvailable.setProperty("checked", simpleble.Adapter.bluetooth_enabled())

	def display_peripherals(self, peripherals: list):
		self.shortcuts.searchIndicator.setProperty("running", False)
		for peripheral in peripherals:
			name = (peripheral.identifier() + " (" + peripheral.address() + ")" if peripheral.identifier() else peripheral.address())
			print(name)
			self.templates.new_button(self.shortcuts.devicesColumn).setProperty("text", name)

	@Slot()
	def select_device(self):
		print("Selected a device")

def normalize(x, y):
	magnitude = sqrt(pow(x, 2) + pow(y, 2))
	if magnitude == 0:
		return 0, 0
	else:
		return x / magnitude, y / magnitude

def position_changed(x, y):
		x, y = normalize(x, y)
		print(f"{x} {y}")

if __name__ == "__main__":

	bridge = UIBridge()

	bluetooth = Bluetooth()

	bluetooth.searchStopped.connect(bridge.display_peripherals)

	stackLayout = bridge.shortcuts.stackLayout
	searchButton = bridge.shortcuts.searchButton
	searchIndicator = bridge.shortcuts.searchIndicator
	controlsButton = bridge.shortcuts.controlsButton
	backButton = bridge.shortcuts.backButton
	joystick = bridge.shortcuts.joystick
	mouseArea = bridge.shortcuts.mouseArea
	controlBG = bridge.shortcuts.controlBG

	# Permite buscar dispositivos si hay Bluetooth
	if bluetooth.adapter:
		searchButton.setProperty("enabled", True)
		searchButton.setProperty("text", "Buscar Dispositivos")

	bridge.change_bluetooth()

	# Configura el botón de búsqueda para que funcione al hacer click
	searchButton.clicked.connect(bluetooth.scan)
	searchButton.clicked.connect(lambda : searchButton.setProperty("enabled", False))
	searchButton.clicked.connect(lambda : searchIndicator.setProperty("running", True))

	# Muestra los controles del robot
	controlsButton.clicked.connect(lambda : stackLayout.setProperty("currentIndex", 1))

	# Muestra la configuración
	backButton.clicked.connect(lambda : stackLayout.setProperty("currentIndex", 0))

	# Recibe la posición del mouse
	mouseArea.positionChangedPy.connect(position_changed)

	# Este comando previene la ejecución de más código por lo que se hace al final
	bridge.app.exec()
