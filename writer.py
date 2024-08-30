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

template_content = open('template/action.qml_disabled', 'r', encoding='utf-8').read()

for action in actions:
    action_name = actions[action]
    for potential in range(len(potential_seq)):
        note_name = potential_seq[potential]
        note_label = potential_labels[potential]
        label = action_name + ' ' + note_label
        id = action + '_' + note_name
        
        plugin_content = (
            template_content
            .replace('{{label}}', label)
            .replace('{{potential}}', str(potential))
            .replace('{{action}}', str(action))
        )
        
        open(identifier(id), 'w', encoding='utf-8').write(plugin_content)
