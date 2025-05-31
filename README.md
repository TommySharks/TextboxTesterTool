# Installation

1) Download the project code as a ZIP file
2) Open your Kristal Installation Folder
3) (Windows) Extract the zip file contents inside /AppData/Roaming/LOVE/kristal/mods/

# Purpose

Extensible Add-On for Kristal that quickly lets you simulate what custom dialogue boxes would look like rendered in-game.

Save time on projects by avoiding needing to recompile your large project over and over to get your text boxes looking as desired in-game.
# Features

## Key Features
### Directly Type Text
- Make minor adjustments to written dialogue within the editor in real time
### Clipboard Functionality
- Ctrl+V to quickly paste written dialogue from your project file for fast testing.
- Export adjusted text to your clipboard  by pressing the Memo icon
- Exported text will appear as cutscene:text("* `YOUR TEXT`", "`PORTRAIT`", "`ACTOR`")
- Example Export: `cutscene:text("* here comes the grub.", "wink", "sans")`
### Adjustable Portrait Position
- Adjust the portrait's X offset and Y offset if necessary

## Support for custom dialogue
### Add a custom Portrait
1) Open /textbox_tester_tool/assets/sprites/face/typer/
2) Create a new folder in the directory with the name of your actor, and place your portrait files inside the new actor folder.
- Custom portrait folders **MUST BE THE SAME NAME** as your actor file
### Add a custom Font
- Place additional custom font files inside /textbox_tester_tool/assets/fonts/

## Notes

Text Modifiers still work while you're typing
- Example: Typing or Pasting `[shake:2]` at the beginning of your dialogue
- After typing in the close bracket, the modifier will disappear from being visible and give you a fresh text box where all future text functions with the modifier active - backspacing the dialogue while "empty" will eventually backspace the close bracket, removing the modifier and revealing the `[shake:2`
