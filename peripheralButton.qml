import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    autoExclusive: true
    checkable: false
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    Layout.fillWidth: true
    width: 150
    height: 80
    text: qsTr("Dispositivo")
    font.pointSize: 16
    onClicked: {
        backend.select_device()
    }

    Connections {
        target: backend
    }
}
