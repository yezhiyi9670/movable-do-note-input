import MuseScore 3.0
import QtQuick 2.0

MuseScore {
    menuPath: "Plugins.Movable Note Input.Turn On"
    description: "Proof-of-concept plugin(s) for the Movable Do Note Input mode. This is a special action that toggles between fixed-Do and movable-Do input modes."
    version: "1.0"
    requiresScore: true
    
    //4.4 title: "~ Movable Note Input: Turn On"
    //4.4 thumbnailName: "../MovableNoteInput.png"
    //4.4 categoryCode: "color-notes"
    
    Component.onCompleted: {
        if (mscoreMajorVersion >= 4 && mscoreMinorVersion <= 3) {
            title= "~ Movable Note Input: Turn On"
            thumbnailName = "../MovableNoteInput.png"
            categoryCode = "color-notes"
        }
    }
    function _quit() {
        (typeof(quit) === 'undefined' ? Qt.quit : quit)();
    }

    onRun: {
        var flag = true;
        // settings.movableDoEnabled = flag;
        curScore.setMetaTag("__movable_note_input_toggle", flag ? "on" : "off");
        _quit();
    }

    // Settings {
	// 	id: settings
	// 	category: "MovableNoteInputPlugin"
	// 	property var movableDoEnabled: true
	// }
}
