import QtQuick

// Sirve para poder arrastrar un objeto (en este caso, joystick)
MouseArea {
    id: mouseArea
    objectName: "mouseArea"
    anchors.fill: parent
    drag.target: parent
    preventStealing: false
    cursorShape: Qt.OpenHandCursor
    signal positionChangedPy(real x, real y)
    // Permite que el joystick se mueva
    onPressed:
    {
        parent.anchors.verticalCenter = undefined
        parent.anchors.horizontalCenter = undefined
    }
    // Vuelve a centrar el joystick cuando se suelta el click
    onReleased:
    {
        parent.anchors.verticalCenter = parent.parent.verticalCenter
        parent.anchors.horizontalCenter = parent.parent.horizontalCenter
    }
    onPositionChanged:
    {
        var control = parent.parent
        // Le manda la posición del joystick a Python relativo al centro de la pantalla
        // La x se invierte para que concuerde con los sistemas de coordenadas comunes
        mouseArea.positionChangedPy(-((control.width - parent.width) / 2 - parent.x), (control.height - parent.height) / 2 - parent.y)
    }
}
