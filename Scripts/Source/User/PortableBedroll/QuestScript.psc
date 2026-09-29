Scriptname PortableBedroll:QuestScript extends Quest
{Central controller for the Portable Bedroll. Places and picks up the bedroll
furniture and handles the optional MCM hotkey.}

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
EndFunction

; Removes a placed bedroll from the world and returns it to the inventory.
Function PickUpBedroll(ObjectReference akBed, Bool abSilent = False)
	If !akBed || akBed.IsDeleted()
		Return
	EndIf
	If akBed.IsFurnitureInUse()
		Debug.Notification("Someone is using your bedroll.")
		Return
	EndIf

	RemoveBedrollRef(akBed)
	Game.GetPlayer().AddItem(PortableBedrollItem, 1, abSilent)
	If abSilent
		Debug.Notification("Your bedroll was packed back into your inventory.")
	EndIf
EndFunction

; Called by the MCM hotkey (see MCM/Config/PortableBedroll/keybinds.json).
; Picks the bedroll up if it is nearby, otherwise lays one down.
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
