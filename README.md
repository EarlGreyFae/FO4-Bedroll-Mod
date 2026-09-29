# Portable Bedroll (Fallout 4)

A simple, lightweight mod: carry a bedroll, lay it down anywhere, sleep, pack it
up, and keep going.

## How it works

| Action | How |
|---|---|
| **Lay the bedroll down** | Use *Portable Bedroll* from **Pip-Boy > Inv > Aid**, press the **keyboard hotkey**, or **hold the controller button** (both set in MCM). |
| **Sleep** | Activate the bedroll as normal. |
| **Pick it back up** | **Sneak** and activate the bedroll, or use the hotkey / controller button near it. It goes back into your Aid tab, ready to use again. |

Extra details:

- Only one bedroll is on the ground at a time.
- Can't be laid down in combat or in Power Armor (you keep the item).
- If you walk or fast travel away without packing it up, it's returned to your
  inventory automatically — it can't get lost.
- The controller button triggers on a **hold** (default: hold Back/View for
  0.75 s), so a normal tap still does its vanilla action. Button and hold time
  are configurable.
- Optional: pack the bedroll up automatically when you wake up.
- The item can still be favorited like any Aid item.

## Requirements

- Fallout 4
- [F4SE](https://f4se.silverlock.org/)
- [Mod Configuration Menu](https://www.nexusmods.com/fallout4/mods/21497)

## Repository layout

```
Scripts/Source/User/PortableBedroll/
  QuestScript.psc      placing / picking up, keyboard + controller hotkeys,
                       MCM settings, auto pack-up
  EffectScript.psc     runs when the Aid item is used
  FurnitureScript.psc  sleep vs. sneak-to-pick-up, auto-return on unload
MCM/Config/PortableBedroll/
  config.json          MCM page (keyboard hotkey, controller button, options)
  keybinds.json        wires the keyboard hotkey to QuestScript.OnHotkey
  settings.ini         default settings
docs/CreationKitSetup.md  how to build PortableBedroll.esp in the Creation Kit
```

## Building

The plugin (`.esp`) and compiled scripts (`.pex`) are produced with the
Fallout 4 Creation Kit. Follow [docs/CreationKitSetup.md](docs/CreationKitSetup.md)
— it's five records and takes about ten minutes.
