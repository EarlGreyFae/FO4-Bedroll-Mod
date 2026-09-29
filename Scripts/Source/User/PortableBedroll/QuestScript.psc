Scriptname PortableBedroll:QuestScript extends Quest
{Central controller for the Portable Bedroll. Places and picks up the bedroll
furniture, and handles the keyboard (MCM) and controller (F4SE) hotkeys.
Requires F4SE and Mod Configuration Menu.}

Potion Property PortableBedrollItem Auto Const Mandatory
{The Aid item the player carries and uses from the Pip-Boy / Favorites.}

Furniture Property PortableBedrollFurniture Auto Const Mandatory
{The sleepable bedroll furniture that gets laid on the ground.}

Float Property PlaceDistance = 90.0 Auto Const
{How far in front of the player the bedroll is laid down.}

Float Property HotkeyPickupRange = 300.0 Auto Const
{How close the player must be for the hotkey to pick the bedroll back up.}

ObjectReference Property DeployedBedroll Auto Hidden
{The bedroll currently lying on the ground, if any.}

String Property ModName = "PortableBedroll" AutoReadOnly

; F4SE gamepad key codes, indexed by the MCM "Controller button" dropdown.
; Index 0 is "Disabled".
Int[] ControllerCodes
Int RegisteredControllerCode = 0
Float ControllerHoldTime = 0.75
Bool AutoPackUp = False
Bool HintShown = False

Int Property HoldTimerID = 1 AutoReadOnly Hidden


; ---------------------------------------------------------------------------
; Setup
; ---------------------------------------------------------------------------

Event OnQuestInit()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterForPlayerSleep()
	Initialize()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	Initialize()
EndEvent

Function Initialize()
	ControllerCodes = new Int[17]
	ControllerCodes[0] = 0     ; Disabled
	ControllerCodes[1] = 266   ; D-Pad Up
	ControllerCodes[2] = 267   ; D-Pad Down
	ControllerCodes[3] = 268   ; D-Pad Left
	ControllerCodes[4] = 269   ; D-Pad Right
	ControllerCodes[5] = 270   ; Start / Menu
	ControllerCodes[6] = 271   ; Back / View
	ControllerCodes[7] = 272   ; Left Stick Click
	ControllerCodes[8] = 273   ; Right Stick Click
	ControllerCodes[9] = 274   ; Left Bumper
	ControllerCodes[10] = 275  ; Right Bumper
	ControllerCodes[11] = 276  ; A / Cross
	ControllerCodes[12] = 277  ; B / Circle
	ControllerCodes[13] = 278  ; X / Square
	ControllerCodes[14] = 279  ; Y / Triangle
	ControllerCodes[15] = 280  ; Left Trigger
	ControllerCodes[16] = 281  ; Right Trigger

	If F4SE.GetVersionRelease() == 0 || !MCM.IsInstalled()
		Debug.MessageBox("Portable Bedroll requires F4SE and Mod Configuration Menu. Hotkeys are disabled, but the bedroll still works from the Pip-Boy.")
		Return
	EndIf

	; MCM custom events are not saved, so re-register on every load.
	RegisterForExternalEvent("OnMCMSettingChange|" + ModName, "OnMCMSettingChange")
	LoadSettings()
EndFunction

Function OnMCMSettingChange(String asModName, String asControlID)
	If asModName == ModName
		LoadSettings()
	EndIf
EndFunction

Function LoadSettings()
	Int index = MCM.GetModSettingInt(ModName, "iControllerButton:Main")
	If index < 0 || index >= ControllerCodes.Length
		index = 0
	EndIf
	ControllerHoldTime = MCM.GetModSettingFloat(ModName, "fHoldTime:Main")
	AutoPackUp = MCM.GetModSettingBool(ModName, "bAutoPackUp:Main")

	Int newCode = ControllerCodes[index]
	If newCode != RegisteredControllerCode
		If RegisteredControllerCode
			UnregisterForKey(RegisteredControllerCode)
		EndIf
		If newCode
			RegisterForKey(newCode)
		EndIf
		RegisteredControllerCode = newCode
	EndIf
EndFunction


; ---------------------------------------------------------------------------
; Hotkeys
; ---------------------------------------------------------------------------

; Controller buttons already do something in vanilla, so the bedroll action
; fires only while the button is *held*; a normal tap is left alone.
Event OnKeyDown(Int aiKeyCode)
	If aiKeyCode == RegisteredControllerCode
		StartTimer(ControllerHoldTime, HoldTimerID)
	EndIf
EndEvent

Event OnKeyUp(Int aiKeyCode, Float afTime)
	If aiKeyCode == RegisteredControllerCode
		CancelTimer(HoldTimerID)
	EndIf
EndEvent

Event OnTimer(Int aiTimerID)
	If aiTimerID == HoldTimerID
		OnHotkey()
	EndIf
EndEvent

; Called by the controller button above and by the MCM keyboard hotkey
; (MCM/Config/PortableBedroll/keybinds.json). Picks the bedroll up if it is
; nearby, otherwise lays one down.
Function OnHotkey()
	If Utility.IsInMenuMode()
		Return
	EndIf
	Actor player = Game.GetPlayer()

	If DeployedBedroll && !DeployedBedroll.IsDeleted() && player.GetDistance(DeployedBedroll) <= HotkeyPickupRange
		PickUpBedroll(DeployedBedroll)
	ElseIf player.GetItemCount(PortableBedrollItem) > 0
		player.RemoveItem(PortableBedrollItem, 1, True)
		DeployBedroll()
	Else
		Debug.Notification("You don't have a bedroll.")
	EndIf
EndFunction


; ---------------------------------------------------------------------------
; Placing / picking up
; ---------------------------------------------------------------------------

; Lays the bedroll down in front of the player. Assumes the item has already
; been removed from the inventory (consumed or taken by the hotkey); if the
; bedroll can't be placed, the item is refunded.
Function DeployBedroll()
	Actor player = Game.GetPlayer()

	If player.IsInCombat()
		Refund("You can't lay out your bedroll during combat.")
		Return
	EndIf
	If player.IsInPowerArmor()
		Refund("You can't lay out your bedroll while in Power Armor.")
		Return
	EndIf

	; Only one bedroll on the ground at a time: pull up the old one first.
	If DeployedBedroll
		RemoveBedrollRef(DeployedBedroll)
	EndIf

	Float angle = player.GetAngleZ()
	ObjectReference bed = player.PlaceAtMe(PortableBedrollFurniture, 1, False, True)
	bed.MoveTo(player, PlaceDistance * Math.Sin(angle), PlaceDistance * Math.Cos(angle), 0.0, False)
	bed.MoveToNearestNavmeshLocation()
	bed.SetAngle(0.0, 0.0, angle)
	bed.Enable()

	DeployedBedroll = bed

	If !HintShown
		Debug.Notification("Sneak and activate the bedroll to pack it up.")
		HintShown = True
	EndIf
EndFunction

; Removes a placed bedroll from the world and returns it to the inventory.
Bool Function PickUpBedroll(ObjectReference akBed, Bool abSilent = False)
	If !akBed || akBed.IsDeleted()
		Return False
	EndIf
	If akBed.IsFurnitureInUse()
		If !abSilent
			Debug.Notification("Someone is using your bedroll.")
		EndIf
		Return False
	EndIf

	RemoveBedrollRef(akBed)
	Game.GetPlayer().AddItem(PortableBedrollItem, 1, abSilent)
	If abSilent
		Debug.Notification("Your bedroll was packed back into your inventory.")
	EndIf
	Return True
EndFunction

; Optional (MCM): pack the bedroll up automatically after sleeping in it.
Event OnPlayerSleepStop(Bool abInterrupted, ObjectReference akBed)
	If !AutoPackUp || !akBed || akBed != DeployedBedroll
		Return
	EndIf
	; Wait for the player to finish getting up before removing the furniture.
	Int tries = 0
	While akBed.IsFurnitureInUse() && tries < 20
		Utility.Wait(0.25)
		tries += 1
	EndWhile
	PickUpBedroll(akBed)
EndEvent


Function Refund(String asReason)
	Game.GetPlayer().AddItem(PortableBedrollItem, 1, True)
	Debug.Notification(asReason)
EndFunction

Function RemoveBedrollRef(ObjectReference akBed)
	If akBed == DeployedBedroll
		DeployedBedroll = None
	EndIf
	akBed.Disable()
	akBed.Delete()
EndFunction
