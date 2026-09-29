Scriptname PortableBedroll:EffectScript extends ActiveMagicEffect
{Attached to the magic effect of the Portable Bedroll Aid item. Using the item
(from the Pip-Boy or a Favorites hotkey / d-pad slot) lays the bedroll down.}

PortableBedroll:QuestScript Property PortableBedrollQuest Auto Const Mandatory

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If akTarget != Game.GetPlayer()
		Return
	EndIf
	; Wait doesn't return until the Pip-Boy is closed, so the bedroll is placed
	; in the world rather than while the game is paused.
	Utility.Wait(0.1)
	PortableBedrollQuest.DeployBedroll()
EndEvent
