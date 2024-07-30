# NoobDocs
## Goals
1. **Lightweight** \
NoobDocs is designed and intended to be snappy on most hardware.
2. **Nice UI** \
The UI should not get in the way of using the program.
3. **Always Accessible Data** \
Data should not be stored in any propriety formats and users should have access to their data at all times.

## Building
NoobDocs is written in the Godot Engine, so any platform that Godot supports, NoobDocs can target. \
**Requirements:**
- [Godot 4.2](https://godotengine.org/download/archive/4.2.2-stable/) or [up](https://godotengine.org/)
- RCedit (if compiling to Windows platforms)

**To build:**
1. Clone or download this repository
2. Extract the files (if you downloaded)
3. Open the Godot project (Godot version 4.2+)
4. In the top right, click "Project"
5. In the drop down menu, select "Export..."
6. To add a build target, you can use the "Add..." button, or to export to Windows Desktop, you can use the build target that is already there.
7. Select the output directory

## Credits:
- MarkdownLabel by daenvil
- Roboto (font)
- Courier Prime (font)
- Material Icons

## NoobDocs Example Sync Server
The NoobDocs example sync server an example implementation of how to write a sync server for NoobDocs. This sync server is usable, however it was more written with the intent of being something that other people can base their own implementations off of.

### Building
**Requirements:**
- [Golang](https://go.dev/)

**To build:**
1. Clone or download this repository
2. Extract the files (if you downloaded)
3. CD into the directory titled "sync_server"
4. Run `go build .`

**IMPORTANT NOTE:** \
The sync server expects to find a file titled `config.json`. If the sync server can not find this file, then it will not launch.