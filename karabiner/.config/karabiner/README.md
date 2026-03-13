# karabiner_config
Configuration for Karabiner-Elements app, used to simplify Swiss-german layout.

# Complex modifications
The remapping was done to avoid the problem in the MacOS terminal which, when selecting "Option as Meta Key", it prevents using
the option key for anything else other than meta (e.g. option can be used to jump from word to word, but it can't be used in
combination with other keys to generate special characters).
This led me to choose between these two alternatives:
  1. Not being able to jump between words (opt + arrows) or deleting whole words (opt + delete/back)
  2. Not being able to create the special characters that are generated in a swiss-german keyboard with option (e.g: ~@[]|{}#)

The complex modifications I added allow to generate these symbols using the Shift key plus others, as can be seen in `complex-modif-remapping.png`.

# Using accents
In my day-to-day, I might still need to use accents, and I removed three keys that contain them. However they can still be generated:
  - Acute accent ``(´)`` with option+`<last-key-in-number-row>`, where `<last-key-in-number-row>` has the symbols ``(`)`` and `(^)` printed.
    - Note that this requires the option key, but I do not expect to ever need acute accents when typing in the terminal.
  - Grave accent ``(`)`` with shift + `<last-key-in-number-row>`
  - Umlaut ``(¨)`` with `<last-key-in-qwertz-row>`, where `<last-key-in-qwertz-row>` has the symbols `(!)` and `(¨)`printed.

# Files
  - `karabiner.json` is an auto-generated file created by Karabiner-Elements. I just copied it to have all information, just in case. It is stored in
  `~/.config/karabiner/`
  - `myconfig.json` is the file I created. It is stored in `~/.config/karabiner/assets/complex_modifications/`. Once stored there, Karabiner-Elements is
  able to detect it and you can add the rules with the Karabiner GUI.

# Keyboard type
Upgrades of Karabiner might result in the software "forgetting" the keyboard type. Despite my computer having ISO layout, the above configuration works if the keyboard type in Karabiner is set as ANSI.
The setting can be found (Karabiner-Elements v15.3.0) in Settings -> Virtual Keyboard -> Keyboard Type.
