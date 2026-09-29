# Portable Bedroll: build and install guide

Right now the mod is **source only**: the plugin (`PortableBedroll.esp`) and
the compiled scripts (`.pex`) have to be made once in the Fallout 4 Creation
Kit. This guide covers everything, starting from a plain Steam install of
Fallout 4. Do the parts in order.

In this guide `<FO4>` means your Fallout 4 folder. On Steam it's usually:

```
C:\Program Files (x86)\Steam\steamapps\common\Fallout 4
```

(To find yours: in Steam, right-click **Fallout 4 > Manage > Browse local files**.)

---

## Part A: install the requirements

### A1. F4SE (Fallout 4 Script Extender)

1. Check your game version: start Fallout 4, and on the main menu the version
   is in the bottom-left corner of the **Settings** screen (for example
   `1.10.984`).
2. Download the F4SE build **for that version** from
   <https://f4se.silverlock.org/>. It's a `.7z` archive; open it with 7-Zip.
3. From the archive's top folder, copy **`f4se_loader.exe`** and every
   **`f4se_*.dll`** into `<FO4>` (next to `Fallout4.exe`).
4. Copy the archive's **`Data`** folder into `<FO4>` and let it merge with the
   existing `Data` folder. This puts F4SE's compiled scripts in
   `<FO4>\Data\Scripts`, and its script sources (`.psc`) in
   `<FO4>\Data\Scripts\Source\...`.
5. From now on, start the game with **`f4se_loader.exe`**, not the normal
   launcher. (Mod managers such as Vortex or MO2 can do this for you.)

To check that it works: in game, open the console with the **`~`** key and
type `getf4seversion`. It should print a version number.

### A2. Mod Configuration Menu (MCM)

1. Download **Mod Configuration Menu** from
   <https://www.nexusmods.com/fallout4/mods/21497>.
2. Install it with your mod manager. To install it manually instead, open
   the download and copy everything inside its `Data` folder into
   `<FO4>\Data`, merging folders when asked. (If the download has no `Data`
   folder, copy its top-level folders, such as `F4SE`, `Interface`, `MCM`
   and `Scripts`, straight into `<FO4>\Data`.)
3. To check that it works: in game, open the pause menu. There should be a
   **Mod Config** entry.

### A3. Creation Kit

1. In Steam, search your library (or the store) for
   **"Fallout 4: Creation Kit"**. It's free for Fallout 4 owners. Install it;
   it installs into `<FO4>`.
2. Unpack the base game's script sources. Open
   `<FO4>\Data\Scripts\Source\Base\`. If there's a **`Base.zip`** file there,
   extract it **into that same folder**, so you end up with files like
   `<FO4>\Data\Scripts\Source\Base\Actor.psc`.
3. Put the F4SE script sources where the compiler can see them. Look in
   `<FO4>\Data\Scripts\Source\` for the `.psc` files F4SE added in step A1.4
   (they're in a `User` or an `F4SE` subfolder, depending on the F4SE
   version). If they're not already in `<FO4>\Data\Scripts\Source\User\`, copy
   them there and overwrite when asked.
4. Tell the Creation Kit where the sources are. Create the file
   `<FO4>\CreationKitCustom.ini` (if it already exists, add to it) with:

   ```ini
   [Papyrus]
   sScriptSourceFolder = ".\Data\Scripts\Source\User"
   sAdditionalImports = "$(source);.\Data\Scripts\Source\Base"
   ```

   This makes the compiler use the F4SE versions of the game scripts (in
   `User`) before the vanilla ones (in `Base`).

---

## Part B: copy this mod's files into the game

From this repository (or the zip you were sent), copy:

| From | To |
|---|---|
| `Scripts\Source\User\PortableBedroll\` (whole folder, 3 `.psc` files) | `<FO4>\Data\Scripts\Source\User\PortableBedroll\` |
| `MCM\Config\PortableBedroll\` (whole folder, 3 files) | `<FO4>\Data\MCM\Config\PortableBedroll\` |

**Check for `MCM.psc`.** Look for `<FO4>\Data\Scripts\Source\User\MCM.psc`.
If it isn't there (some MCM downloads don't include it), copy
`Scripts\Source\CompileHeaders\MCM.psc` from this mod into
`<FO4>\Data\Scripts\Source\User\`. It only lets the compiler know the MCM
functions exist; never compile it on its own.

---

## Part C: build the plugin in the Creation Kit

### C1. Open the Creation Kit

1. Start **Creation Kit** from Steam. If it asks to extract scripts or unpack
   archives, answer **Yes**.
2. **File > Data...**, double-click **`Fallout4.esm`** so it has a check mark,
   then click **OK**. Loading takes a minute or two; ignore warnings in the
   log window.

### C2. Compile the scripts

1. **File > Compile Papyrus Scripts...** In the list, tick
   - `PortableBedroll:QuestScript`
   - `PortableBedroll:EffectScript`
   - `PortableBedroll:FurnitureScript`
2. Click **Compile**. All three have to succeed. The compiled files appear in
   `<FO4>\Data\Scripts\PortableBedroll\` (`QuestScript.pex`,
   `EffectScript.pex`, `FurnitureScript.pex`).

If compiling fails, the message usually says why:
- *"unable to find type Actor"* (or `ObjectReference`, `Quest`, ...): the
  base sources from A3.2 or the ini from A3.4 are missing.
- *"RegisterForKey is not a function"* or *"F4SE is not a known user-defined
  type"*: the F4SE sources from A3.3 aren't in `Source\User`.
- *"MCM is not a known user-defined type"*: `MCM.psc` from Part B is missing.

Send me the exact error text and I'll fix it.

### C3. Create the records

All of these are in the **Object Window** (the window with the category tree
on the left). To create a record, select the category, right-click in the
list on the right, and choose **New**. After creating a record, click **OK**,
then double-click it again to reopen it. Some tabs (like Scripts) only work
once the record has been saved once.

**1. Quest** (*Character > Quest*)

- **ID**: `PortableBedrollQuest`
- **Quest Data** tab: tick **Start Game Enabled**. Make sure **Run Once** is
  *not* ticked. Leave everything else.
- Click **OK**. Scripts are added in step 5 below.

**2. Furniture** (*WorldObjects > Furniture*)

1. In the filter box above the list, type `SleepingBag`.
2. Find the plain sleeping bag. Its name is "Sleeping Bag" and its Editor ID
   does **not** start with `Workshop` (it's most likely
   `NpcBedSleepingBagSleep01`).
3. Right-click it, **Duplicate**. A copy appears, usually named with
   `DUPLICATE000` on the end.
4. Double-click the copy and set:
   - **ID**: `PortableBedrollFurniture`
   - **Name**: `Bedroll`
5. Click **OK**. If a box asks whether to create a new object, click **No**.
   The duplicate is already your own copy, so **No** just renames it. The
   original sleeping bag must stay unchanged.

**3. Magic Effect** (*Magic > Magic Effect*)

- **ID**: `PortableBedrollEffect`
- **Name**: `Lay Down Bedroll`
- **Effect Archetype**: `Script`
- **Casting Type**: `Fire and Forget`
- **Delivery**: `Self`
- Flags to tick: **Hide in UI**, **No Duration**, **No Magnitude**,
  **No Area**, **Painless**
- Click **OK**.

**4. Aid item** (*Items > Potion*)

- **ID**: `PortableBedrollItem`
- **Name**: `Portable Bedroll`
- **Weight**: `2`, **Value**: `20`
- Leave **Food Item** and **Medicine** unticked.
- **Consume Sound**: `NONE` if it's in the list; otherwise leave it.
- **Model**: leave empty for now. (The item works, but shows no 3D model in
  the Pip-Boy.)
- **Effects** list: right-click **New**, pick `PortableBedrollEffect`, and set
  Magnitude `0`, Area `0`, Duration `0`. Click **OK**.
- Click **OK**.

**5. Attach the scripts**

Every property name matches a record's ID, so **Auto-Fill All** fills
everything in:

| Record | Where | Script to add |
|---|---|---|
| `PortableBedrollQuest` | **Scripts** tab | `PortableBedroll:QuestScript` |
| `PortableBedrollFurniture` | **Scripts** box (bottom right) | `PortableBedroll:FurnitureScript` |
| `PortableBedrollEffect` | **Papyrus Scripts** box | `PortableBedroll:EffectScript` |

For each one: open the record, click **Add** in the scripts box, pick the
script, click **OK**. Then select the script, click **Properties**, click
**Auto-Fill All**, check that every property now has a value, and click
**OK** twice.

**6. Start with a bedroll** (optional; you can also add one from the console)

1. Open `PortableBedrollQuest`, **Quest Aliases** tab, right-click **New
   Reference Alias**.
2. **Alias Name**: `Player`. Choose **Specific Reference**, click **Select
   Forced Reference**, set Cell to `(any)` and Ref to `PlayerRef`, **OK**.
3. In the **Alias Inventory** box, right-click **New**, pick
   `PortableBedrollItem`, count `1`. Click **OK** twice.

### C4. Save

**File > Save**, name it `PortableBedroll.esp`. It's saved in `<FO4>\Data\`.

### C5. Connect the keyboard hotkey to the quest

1. In the Object Window, go back to *Character > Quest* and find
   `PortableBedrollQuest`. Look at its **Form ID** column, for example
   `01000F99`.
2. Remove the first two characters and any leading zeros. `01000F99` becomes
   `F99`.
3. Open `<FO4>\Data\MCM\Config\PortableBedroll\keybinds.json` in Notepad and
   change `"PortableBedroll.esp|800"` to use your number, for example
   `"PortableBedroll.esp|F99"`. Save.

Close the Creation Kit.

---

## Part D: turn it on and test

1. **Enable the plugin.**
   - Vortex or MO2: `PortableBedroll.esp` shows in the plugin list; enable it.
   - No mod manager:
     1. Turn on mod loading (one-time). Open
        `Documents\My Games\Fallout4\Fallout4Prefs.ini`, find the `[Launcher]`
        section, and set `bEnableFileSelection=1`. Then open (or create)
        `Documents\My Games\Fallout4\Fallout4Custom.ini` and add:
        ```ini
        [Archive]
        bInvalidateOlderFiles=1
        sResourceDataDirsFinal=
        ```
     2. Press **Win+R**, type `%LOCALAPPDATA%\Fallout4`, and press Enter.
        Open `plugins.txt` in Notepad (create it if it's missing), add the
        line `*PortableBedroll.esp` at the end, and save. The `*` means
        enabled.
2. Start the game with **`f4se_loader.exe`** and load a save.
3. If you skipped C3 step 6, get a bedroll from the console: press **`~`**,
   type `help "Portable Bedroll" 4`, press Enter, and note the ID in the
   `ALCH` line (for example `01000F9C`). Then type
   `player.additem 01000F9C 1` with your ID, press Enter, and close the
   console.

### Test checklist

- [ ] **Pip-Boy > Inv > Aid > Portable Bedroll**: a bedroll appears in front
      of you, and the item is gone from your inventory.
- [ ] Activate the bedroll: the sleep menu opens and sleeping works.
- [ ] Crouch (sneak) and activate the bedroll: it disappears and the item is
      back in your Aid tab.
- [ ] Pause menu > **Mod Config > Portable Bedroll**: bind a keyboard key.
      Press it: the bedroll is laid down. Press it next to the bedroll: it's
      picked up.
- [ ] On a controller, hold **Back/View** for about 1 second: same as the
      keyboard key. A quick tap still does the button's normal action.
- [ ] Try laying it down in combat or in Power Armor: you get a message and
      keep the item.
- [ ] Lay it down and fast travel away: you get a message and the item is
      back in your inventory.
- [ ] Turn on **Pack up automatically after sleeping** in MCM, then sleep: the
      bedroll packs itself up when you wake.

For anything that fails, tell me which step, what happened, and any on-screen
message. For script problems, the Papyrus log is the most useful: in
`Documents\My Games\Fallout4\Fallout4Custom.ini` add

```ini
[Papyrus]
bEnableLogging=1
bEnableTrace=1
bLoadDebugInformation=1
```

then reproduce the problem and send me
`Documents\My Games\Fallout4\Logs\Script\Papyrus.0.log`.
