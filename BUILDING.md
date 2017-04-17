# Running the game

The easiest way to run the game is to download and run the installer. The below instructions detail how to build the .exe and how to build the installer, if you make changes to the engine of the game & need to build a distributable installer.

# Building the Executable

I followed the instructions here: https://love2d.org/wiki/Game_Distribution#Creating_a_Windows_Executable, specifically, zipping the game files and renaming the zip with a `.love` extension, then using the `cat` command on OSX to concatenate the `.love` file onto the `love.exe` for Windows. Then I used Resource Hacker (in Windows) to change the icon. I used the LOVE icon as a template, opened it in gimp and replaced each layer with an identically-sized layer that included the game's icon. I created the game's icon by using the ["Tools" icon](https://thenounproject.com/term/tools/561840) by Viktor Vorobyev and recoloring it with the LOVE icon colors (by editing the SVG). Then I copied all the DLLs that came with LOVE into the same folder as the executable so it would work.

# Building the Installer

I couldn't get the latest NSIS (3.0.1) to properly mark the installer as requiring admin execution level (I was able to use Resource Hacker to verify that it wasn't configured incorrectly, but I couldn't fix it there as that messed up the installer's checksum & then the whole thing refused to run).

So instead I zipped the executable and DLLs described above and used NSIS's zip2exe and added a couple lines to use the app's icon for the Setup executable and to add the app to the Start Menu. One is in `NSIS\Contrib\zip2exe\modern.nsh`, immediately after `!include "MUI2.nsh"`:

```
!define MUI_ICON "Z:\Downloads\game-designer\GameDesigner.ico"
```

The other is in `NSIS\Contrib\zip2exe\base.nsh`, immediately after `Call zip2exe.SetOutPath`:

```
createShortCut "$SMPROGRAMS\GameDesigner.lnk" "$INSTDIR\GameDesigner.exe" "" "$INSTDIR\GameDesigner.ico"
```
