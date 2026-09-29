# Building PortableBedroll.esp in the Creation Kit

The Papyrus scripts in `Scripts/Source/User/PortableBedroll/` hold all of the
mod's logic. The plugin itself (`PortableBedroll.esp`) only needs five records,
which are created once in the Fallout 4 Creation Kit (CK) as described below.

> Tip: create the records **in the order listed**. The first new form in an
> empty plugin gets the local FormID `0x800`, which is what
> `MCM/Config/PortableBedroll/keybinds.json` points at for the quest. If your
> quest ends up with a different ID, update the `"form"` value there.

## 0. Prepare

1. Copy `Scripts/Source/User/PortableBedroll/` into
   `Fallout 4/Data/Scripts/Source/User/PortableBedroll/`.
2. Launch the CK, **File > Data...**, tick `Fallout4.esm` only, click **OK**.
3. Install the script *sources* the mod builds against:
   - **F4SE**: copy its `Data/Scripts/Source/User/*.psc` (F4SE's versions of
     `ScriptObject.psc`, `F4SE.psc`, etc.) into the same folder, overwriting.
   - **MCM**: copy `MCM.psc` from the MCM download into
     `Data/Scripts/Source/User/`.
4. Compile the scripts: **Gameplay > Papyrus Script Manager**, select the three
   `PortableBedroll:*` scripts, right-click **Compile**.

## 1. Quest – `PortableBedrollQuest`

*Character > Quest*, right-click **New**.

| Field | Value |
|---|---|
| ID | `PortableBedrollQuest` |
| Start Game Enabled | ✔ |
| Run Once | ✘ |
| Priority | 0 |

Save the quest, re-open it, go to the **Scripts** tab and add
`PortableBedroll:QuestScript`. Fill the properties after steps 2–4 exist:

| Property | Value |
|---|---|
| `PortableBedrollItem` | `PortableBedrollItem` |
| `PortableBedrollFurniture` | `PortableBedrollFurniture` |

## 2. Furniture – `PortableBedrollFurniture`

1. *WorldObjects > Furniture*, filter for `sleep` / `bag` and pick a plain,
   **non-workshop** ground sleeping bag (one without a Workshop/Build keyword).
2. Right-click it **Duplicate**, then open the copy and rename its ID to
   `PortableBedrollFurniture` and its name to `Bedroll`. Never edit the
   vanilla record itself.
3. Remove any `WorkshopItemKeyword` / workshop scripts if present.
4. **Scripts**: add `PortableBedroll:FurnitureScript`, set
   `BedrollQuest` = `PortableBedrollQuest`.

## 3. Magic Effect – `PortableBedrollEffect`

*Magic > Magic Effect*, **New**.

| Field | Value |
|---|---|
| ID | `PortableBedrollEffect` |
| Effect Archetype | `Script` |
| Casting Type | `Fire and Forget` |
| Delivery | `Self` |
| Flags | `No Duration`, `No Magnitude`, `No Area`, `Hide in UI`, `Painless` |

**Papyrus Scripts**: add `PortableBedroll:EffectScript`, set
`BedrollQuest` = `PortableBedrollQuest`.

## 4. Aid item – `PortableBedrollItem`

*Items > Potion*, **New**.

| Field | Value |
|---|---|
| ID | `PortableBedrollItem` |
| Name | `Portable Bedroll` |
| Model | any rolled-up sleeping bag / bedroll mesh (filter *Static* for `sleeping`) |
| Weight | `2.0` (your choice) |
| Value | `20` |
| Consume Sound | *none* |
| Food Item / Medicine | ✘ / ✘ |
| Effects | `PortableBedrollEffect`, magnitude 0, duration 0 |

Because it is an Aid item it shows up under **Pip-Boy > Inv > Aid** and can be
**favorited**, which lets the player bind it to a number key (PC) or a d-pad
slot (controller) with no extra requirements.

## 5. Give the player a bedroll

Pick one (or both):

- **Start with it** – on `PortableBedrollQuest` add a *Reference Alias*
  `Player` (Specific Reference: `PlayerRef`) and in its **Alias Inventory**
  add `PortableBedrollItem` ×1.
- **Sell / craft it** – add `PortableBedrollItem` to a vendor leveled list, or
  create a Constructible Object at the Chemistry Station
  (e.g. 2× Cloth, 1× Leather).

## 6. Save & (optionally) flag as ESL

Save as `PortableBedroll.esp`. The plugin has only a handful of records, so it
can be ESL-flagged (e.g. in xEdit) to avoid using a load-order slot.

## 7. Package

```
Data/
  PortableBedroll.esp
  Scripts/PortableBedroll/QuestScript.pex
  Scripts/PortableBedroll/EffectScript.pex
  Scripts/PortableBedroll/FurnitureScript.pex
  Scripts/Source/User/PortableBedroll/*.psc      (optional, for other modders)
  MCM/Config/PortableBedroll/config.json
  MCM/Config/PortableBedroll/keybinds.json
  MCM/Config/PortableBedroll/settings.ini
```

## In-game test checklist

- [ ] `player.additem <PortableBedrollItem FormID> 1` (or start a new game).
- [ ] Use it from the Aid tab → bedroll appears in front of you, item is gone.
- [ ] Activate it → sleep menu opens, sleeping works.
- [ ] Sneak + activate → bedroll disappears, item is back in the Aid tab.
- [ ] Favorite the item, use the number key / d-pad → bedroll is laid down.
- [ ] Try it in combat and in Power Armor → refused, item is kept.
- [ ] Lay it down, fast travel away → item is returned to your inventory.
- [ ] MCM: bind the keyboard hotkey, press to lay down, press near it to pick up.
- [ ] MCM: pick a controller button, hold it to lay down / pick up; a quick
      tap still does the button's normal action.
- [ ] MCM: enable "Pack up automatically after sleeping", sleep → item returns.
