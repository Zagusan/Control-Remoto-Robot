

/*
    This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
    It is supposed to be strictly declarative and only uses a subset of QML. If you edit
    this file manually, you might introduce QML code that is not supported by Qt Design Studio.
    Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
    */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Page  {
    id: window
    visible: true
    width: 720
    height: 1280

    Connections {
        // Se conecta a los eventos de Python
        target: backend

        // Crea funciones para los eventos definidos en Python
        function onChangeBluetooth(enabled){
            print("Changing bluetooth now")
            bluetoothEnabled.checked = enabled
        }
        function onEnableSearchButton(){
            print("Enabling search button")
            search.enabled = true
            search.text = "Buscar Dispositivos"
        }
        function onSearchStopped(){
            //search.enabled = true
            searchIndicator.running = false
        }
    }

    // Permite cambiar de página en la interfaz
    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: 0

        Frame {
            id: config
            Layout.fillWidth: true
            Layout.fillHeight: true
            leftPadding: 50
            rightPadding: 50
            topPadding: 50
            bottomPadding: 50

            ColumnLayout {
                id: mainColumnLayout
                anchors.fill: parent
                spacing: 30
                uniformCellSizes: false

                Rectangle {
                    id: bluetooth
                    width: 450
                    height: 350
                    color: "#ffffff"
                    radius: 8
                    border.width: 0
                    anchors.topMargin: 0
                    Layout.fillWidth: false
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    clip: false

                    Frame {
                        anchors.fill: parent
                        leftPadding: 20
                        rightPadding: 20
                        topPadding: 20
                        bottomPadding: 20

                        ColumnLayout {
                            id: btColumnLayout
                            x: 0
                            y: 0
                            anchors.fill: parent
                            spacing: 20
                            uniformCellSizes: true

                            CheckBox {
                                id: bluetoothEnabled
                                width: 150
                                height: 80
                                text: qsTr("Bluetooth")
                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                enabled: false
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                font.pointSize: 16
                                display: AbstractButton.TextBesideIcon
                                autoExclusive: true
                                checkable: true
                            }

                            Button {
                                id: toControls
                                width: 150
                                height: 80
                                text: qsTr("Controlar Robot")
                                enabled: true
                                font.hintingPreference: Font.PreferDefaultHinting
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                font.pointSize: 16
                                checkable: false
                                highlighted: false
                                // Cambia a los controles al hacer click en el botón
                                onClicked: {
                                    stackLayout.currentIndex = 1
                                }
                            }

                            Button {
                                id: search
                                width: 150
                                height: 80
                                text: qsTr("Adaptador de Bluetooth no Disponible")
                                enabled: false
                                font.hintingPreference: Font.PreferDefaultHinting
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                font.pointSize: 16
                                checkable: false
                                highlighted: false
                                flat: false
                                // Cuando se hace click en el botón este se desactiva,
                                // activa el indicador de carga y comienza la búsqueda de Bluetooth
                                onClicked: {
                                    enabled = false
                                    searchIndicator.running = true
                                    backend.bt_start_search()
                                }
                            }

                            BusyIndicator {
                                id: searchIndicator
                                running: false
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                enabled: false
                            }
                        }
                    }
                }

                Rectangle {
                    id: devices
                    width: 200
                    height: 200
                    color: "#ffffff"
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Frame {
                        anchors.fill: parent
                        leftPadding: 20
                        rightPadding: 20
                        topPadding: 20
                        bottomPadding: 20

                        ScrollView {
                            id: devicesScroll
                            anchors.fill: parent
                            clip: true

                            ColumnLayout {
                                id: devicesColumnLayout
                                anchors.fill: parent
                                // Aquí se almacenan los botones creados
                                property var buttons: []
                                // Esto carga un archivo con la configuración de los botones
                                // para los dispositivos encontrados
                                property var buttonComponent: Qt.createComponent("peripheralButton.qml")

                                Connections {
                                    // Se conecta a los eventos de Python
                                    target: backend

                                    // Crea un botón y lo añade a la lista "buttons"
                                    function onNewPeripheralButton(name){
                                        print("Creating new button for " + name)
                                        var button = devicesColumnLayout.buttonComponent.createObject(devicesColumnLayout)
                                        button.text = qsTr(name)

                                        devicesColumnLayout.buttons.push(button)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: control
            width: 200
            height: 200
            color: "#000000"
            border.width: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            // Sirve para poder arrastrar un objeto (en este caso, joystick)
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: joystick
                preventStealing: false
                cursorShape: Qt.OpenHandCursor
                // Permitir que joystick se mueva cuando se hace click
                onPressed: {
                    joystick.anchors.verticalCenter = undefined
                    joystick.anchors.horizontalCenter = undefined
                }
                // Devolver al joystick al centro
                onReleased: {
                    joystick.anchors.verticalCenter = mouseArea.verticalCenter
                    joystick.anchors.horizontalCenter = mouseArea.horizontalCenter
                }

                Rectangle {
                    id: joystick
                    width: 200
                    height: 200
                    color: "#cbcbcb"
                    // Convierte al rectángulo en un círculo
                    radius: 100
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Item {
        id: __materialLibrary__
    }
}
