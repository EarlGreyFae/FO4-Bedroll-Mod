Scriptname MCM Native Hidden
{Compile-time header for Mod Configuration Menu, used ONLY if your MCM
download did not include MCM.psc. Do not compile this file itself; the real
MCM.pex from the MCM mod is what runs in game.}

Bool Function IsInstalled() native global
Int Function GetModSettingInt(String asModName, String asSettingName) native global
Bool Function GetModSettingBool(String asModName, String asSettingName) native global
Float Function GetModSettingFloat(String asModName, String asSettingName) native global
String Function GetModSettingString(String asModName, String asSettingName) native global
