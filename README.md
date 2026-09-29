# Portable Bedroll (Fallout 4)

A simple, lightweight mod: carry a bedroll, lay it down anywhere, sleep, pack it
up, and keep going.

## How it works

| Action | How |
|---|---|
| **Lay the bedroll down** | Use *Portable Bedroll* from **Pip-Boy > Inv > Aid**, or from a **Favorites** hotkey (number key on PC, d-pad on controller). Optional MCM hotkey too. |
| **Sleep** | Activate the bedroll as normal. |
| **Pick it back up** | **Sneak** and activate the bedroll. It goes back into your Aid tab, ready to use again. |

Extra details:

- Only one bedroll is on the ground at a time.
- Can't be laid down in combat or in Power Armor (you keep the item).
- If you walk or fast travel away without packing it up, it's returned to your
  inventory automatically — it can't get lost.
- With [Mod Configuration Menu](https://www.nexusmods.com/fallout4/mods/21497)
  you can bind a dedicated hotkey: press it to lay the bedroll down, press it
  again near the bedroll to pick it up.

## Requirements

- Fallout 4
- *Optional:* F4SE + MCM for the dedicated keyboard hotkey. Without them, use
  the built-in Favorites hotkeys, which also work on controller.

## Repository layout

```
Scripts/Source/User/PortableBedroll/
  QuestScript.psc      placing / picking up logic, MCM hotkey handler
  EffectScript.psc     runs when the Aid item is used
  FurnitureScript.psc  sleep vs. sneak-to-pick-up, auto-return on unload
MCM/Config/PortableBedroll/
  config.json          MCM page with the hotkey
  keybinds.json        wires the hotkey to QuestScript.OnHotkey
docs/CreationKitSetup.md  how to build PortableBedroll.esp in the Creation Kit
```

## Building

The plugin (`.esp`) and compiled scripts (`.pex`) are produced with the
Fallout 4 Creation Kit. Follow [docs/CreationKitSetup.md](docs/CreationKitSetup.md)
— it's five records and takes about ten minutes.
