local addonName, Locksmith = ...

LocksmithDB = LocksmithDB or {}

local constants = Locksmith.constants

local LPSpellName = GetSpellInfo(1804)

function isRed(color)
	for k,pigment in ipairs(color) do
		if constants.red[k]~=floor(pigment*255) then return false end
	end
	return true
end

function isLocked()
	local ttLocked = GameTooltipTextLeft2
	if ttLocked and ttLocked:GetText()=="Locked" then return true end
	return false
end

local function setCursor(able)
	if able then
		SetCursor("Interface/Cursor/PickLock")
	else
		SetCursor("Interface/Cursor/UnablePickLock")
	end
end

local function enterBag(able,bag,slot)
	LocksmithButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetBagItem(bag,slot)
		if able then
			self:SetAttribute("macrotext",format("/cast %s\n/use %s %s", LPSpellName, bag, slot))
		else
			self:SetAttribute("macrotext", nil)
		end
		setCursor(able)
	end)
end

local function enterTrade(able)
	LocksmithButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetTradeTargetItem(7)
		if able then
			self:SetAttribute("macrotext",format("/cast %s\n/run ClickTargetTradeButton(7)", LPSpellName))
		else
			self:SetAttribute("macrotext", nil)
		end
		setCursor(able)
	end)
end

local function positionIcon(target)
	LocksmithButton:SetAllPoints(target)
	LocksmithButton:SetMouseMotionEnabled(true)
	LocksmithButton:Show()
end

if select(3,UnitClass("player"))==4 then
	GameTooltip:HookScript("OnTooltipSetItem", function(self)
		if InCombatLockdown() then return end
		local focusFrame
		focusFrame = GetMouseFoci()[1]
		if not focusFrame or focusFrame:GetObjectType() ~= "Button" then return end
		
		if not IsAltKeyDown() then return end

		if focusFrame:GetName() == "TradeRecipientItem7ItemButton" then
			if not isLocked() then return end
			local red = isRed{GameTooltipTextLeft2:GetTextColor()}
			enterTrade(not red)
			positionIcon(focusFrame)
		else
			local focusParent = focusFrame:GetParent()
			local bag,slot = focusParent:GetID(),focusFrame:GetID()
			if bag > 5 or bag < 0 then return end
			local containerInfo = C_Container.GetContainerItemInfo(bag,slot)
			if not containerInfo then return end

			local link, itemId, icon, hasLoot = containerInfo.hyperlink, containerInfo.itemID, containerInfo.iconFileID, containerInfo.hasLoot

			if constants.practiceLock~=itemId and not hasLoot then return end
			if not isLocked() then return end

			local red = isRed{GameTooltipTextLeft2:GetTextColor()}

			enterBag(not red,bag,slot)
			positionIcon(focusFrame)
		end
	end)
end