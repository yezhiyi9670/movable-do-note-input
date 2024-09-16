import shutil
import os

if os.path.exists('dist/'):
    shutil.rmtree('dist/')

os.mkdir('dist/')

# ======================================================================================

def identifier(label: str):
    return 'dist/~MovableDoInput_' + label + '.qml'

flags = {
    'true': 'on',
    'false': 'off'
}

template_content = open('template/switch.qml_disabled', 'r', encoding='utf-8').read()

for flag in flags:
    label = 'Turn ' + flags[flag].capitalize()
    id = '!turn_' + flags[flag]
    
    plugin_content = (
        template_content
        .replace('{{label}}', label)
        .replace('{{flag}}', flag)
    )
    
    open(identifier(id), 'w', encoding='utf-8').write(plugin_content)

# ======================================================================================

actions = {
    'note': 'Note',
    'chord': 'Chord',
    'insert': 'Insert'
}
potential_seq = ['1', '5', '2', '6', '3', '7', '4']
potential_labels = ['Do', 'Sol', 'Re', 'La', 'Mi', 'Ti', 'Fa']

assoc_character = {
    'note_1': 'd',
    'note_2': 'r',
    'note_3': 'm',
    'note_4': 'f',
    'note_5': 's',
    'note_6': 'l',
    'note_7': 't',
    'chord_1': 'D',
    'chord_2': 'R',
    'chord_3': 'M',
    'chord_4': 'F',
    'chord_5': 'S',
    'chord_6': 'L',
    'chord_7': 'T',
}

template_content = open('template/action.qml_disabled', 'r', encoding='utf-8').read()

for action in actions:
    action_name = actions[action]
    for potential in range(len(potential_seq)):
        note_name = potential_seq[potential]
        note_label = potential_labels[potential]
        label = action_name + ' ' + note_label
        id = action + '_' + note_name
        
        insert_character = assoc_character.get(id)
        
        if insert_character:
            insert_character = "'" + insert_character + "'"
        else:
            insert_character = 'null'
        
        plugin_content = (
            template_content
            .replace('{{label}}', label)
            .replace('{{potential}}', str(potential))
            .replace('{{action}}', str(action))
            .replace('{{character}}', insert_character)
        )
        
        open(identifier(id), 'w', encoding='utf-8').write(plugin_content)
