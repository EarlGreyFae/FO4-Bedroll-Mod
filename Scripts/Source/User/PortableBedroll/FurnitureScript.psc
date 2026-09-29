Scriptname PortableBedroll:FurnitureScript extends ObjectReference
{Attached to the placed bedroll furniture. Activate normally to sleep;
activate while sneaking to pick it back up.}

PortableBedroll:QuestScript Property PortableBedrollQuest Auto Const Mandatory

Event OnLoad()
	; Intercept activation so we can choose between sleeping and picking up.
	BlockActivation(True, False)
EndEvent

Event OnActivate(ObjectReference akActionRef)
	Actor player = Game.GetPlayer()
	If akActionRef != player
		Return
	EndIf

	If player.IsSneaking()
		PortableBedrollQuest.PickUpBedroll(Self)
	Else
		; Run the normal furniture activation, which opens the sleep menu.
		Activate(player, True)
	EndIf
EndEvent

Event OnUnload()
	; The player left the area (fast travel, door, etc.) without packing up.
	; Return the bedroll automatically so it can never be lost.
	If !IsDeleted()
		PortableBedrollQuest.PickUpBedroll(Self, True)
	EndIf
EndEvent
