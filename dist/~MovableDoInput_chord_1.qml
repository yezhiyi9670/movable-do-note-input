import MuseScore 3.0
import QtQuick 2.0

MuseScore {
    menuPath: "Plugins.Movable Note Input.Chord Do"
    description: "Proof-of-concept plugin(s) for the Movable Do Note Input mode."
    version: "1.0"
    requiresScore: true
    
    //4.4 title: "~ Movable Note Input: Chord Do"
    //4.4 thumbnailName: "../MovableNoteInput.png"
    //4.4 categoryCode: "color-notes"
    
    Component.onCompleted: {
        if (mscoreMajorVersion >= 4 && mscoreMinorVersion <= 3) {
            title= "~ Movable Note Input: Chord Do"
            thumbnailName = "../MovableNoteInput.png"
            categoryCode = "color-notes"
        }
    }
    function _quit() {
        (typeof(quit) === 'undefined' ? Qt.quit : quit)();
    }
    function isInTextInput() {
        var selection = curScore.selection;
        if(!selection.isRange && selection.elements.length == 1) {
            if([
                Element.TEXT, Element.SYMBOL, Element.MEASURE_NUMBER, Element.INSTRUMENT_NAME,
                Element.AMBITUS, Element.DYNAMIC, Element.LYRICS, Element.JUMP, Element.FINGERING,
                Element.TEMPO_TEXT, Element.STAFF_TEXT, Element.SYSTEM_TEXT, Element.REHEARSAL_MARK,
                Element.INSTRUMENT_CHANGE, Element.STAFFTYPE_CHANGE, Element.HARMONY, Element.FRET_DIAGRAM,
                Element.BEND, Element.TAB_DURATION_SYMBOL, Element.HAIRPIN, Element.LET_RING,
                Element.TEXTLINE, Element.TEXTLINE_BASE, Element.LYRICSLINE, Element.GLISSANDO
            ].indexOf(selection.elements[0].type) != -1) {
                var character = 'D';
                var element = selection.elements[0];
                if(character != null && element.text != undefined) {
                    element.text = element.text + character;
                }
                return true;
            }
        }
        return false;
    }
    function getElementTick(element) {
        var segment = element;
        while (segment.parent && segment.type != Element.SEGMENT) {
            segment = segment.parent;
        }
        return segment.tick;
    }
    onRun: {
        if(isInTextInput()) {
            _quit();
            return;
        }

        var keysig_potential = 0;
        // var isEnabled = settings.movableDoEnabled;
        var isEnabled = curScore.metaTag("__movable_note_input_toggle").toLowerCase() == 'on';

        if(isEnabled) {
            // == 1. Find position
            var cursor = curScore.newCursor();
            var selectedElement = null;
            if(curScore.selection.isRange) {
                cursor.rewind(Cursor.SELECTION_START); // Only works if selection is a range
                selectedElement = cursor.element;
            } else {
                cursor.rewind(Cursor.SCORE_START);
                for (var i in curScore.selection.elements) {
                    var element = curScore.selection.elements[i];
                    cursor.rewindToTick(getElementTick(element));
                    cursor.track = element.track;
                    selectedElement = element;
                    break;
                }
            }
            keysig_potential = cursor.keySignature;

            // == 2. Kill switch
            if(selectedElement) {
                var part = selectedElement.staff.part;
                if(part.hasDrumStaff) {
                    keysig_potential = 0;
                }
            }
        }

        // == 3. Calculate note
        var potential_sequence = [
            'c', 'g', 'd', 'a', 'e', 'b', 'f'
        ];
        var intent_potential = 0;
        var desired_potential = intent_potential + keysig_potential;
        var desired_note = potential_sequence[(desired_potential + potential_sequence.length) % potential_sequence.length];

        // == 4. Action
        var action_prefix = 'chord-';
        var action = action_prefix + desired_note;
        cmd(action);
        
        _quit();
    }

    // Settings {
	// 	id: settings
	// 	category: "MovableNoteInputPlugin"
	// 	property var movableDoEnabled: true
	// }
}
