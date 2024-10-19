

/*
    This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
    It is supposed to be strictly declarative and only uses a subset of QML. If you edit
    this file manually, you might introduce QML code that is not supported by Qt Design Studio.
    Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: window
    visible: true
    width: 720
    height: 1280

    // Permite cambiar de página en la interfaz
    StackLayout {
        id: stackLayout
        objectName: "stackLayout"
        anchors.fill: parent
        currentIndex: 1

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
                                id: bluetoothAvailable
                                objectName: "bluetoothAvailable"
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
                                objectName: "controls"
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
                            }

                            Button {
                                id: search
                                objectName: "search"
                                width: 150
                                height: 80
                                text: qsTr("Adaptador de Bluetooth no disponible")
                                enabled: false
                                font.hintingPreference: Font.PreferDefaultHinting
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                font.pointSize: 16
                                checkable: false
                                highlighted: false
                                flat: false
                            }

                            BusyIndicator {
                                id: searchIndicator
                                objectName: "searchIndicator"
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
                                objectName: "devices"
                                anchors.fill: parent
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: control
            objectName: "controlBG"
            width: 200
            height: 200
            color: "#000000"
            border.width: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Button {
                id: back
                objectName: "back"
                x: 10
                y: 10
                width: 150
                height: 50
                visible: true
                text: qsTr("← Volver")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 10
                anchors.topMargin: 10
                z: 10
                font.pointSize: 16
                layer.enabled: false
            }
            Rectangle {
                id: joystick
                objectName: "joystick"
                width: 200
                height: 200
                color: "#cbcbcb"
                // Convierte al rectángulo en un círculo
                radius: 100
                border.color: "#cbcbcb"
                anchors.verticalCenter: parent.verticalCenter
                z: 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: center
                x: 260
                y: 540
                width: 220
                height: 220
                opacity: 1
                color: "#000000"
                radius: 110
                border.color: "#666666"
                border.width: 4
                anchors.verticalCenter: parent.verticalCenter
                z: 1
                objectName: "joystick"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Item {
        id: __materialLibrary__
    }
}
