-- © 2023 Josh 'Kkthnx' Russell All Rights Reserved

-- Create a frame for the module
local Module = CreateFrame("Frame")
-- Register the events for the module
Module:RegisterEvent("VARIABLES_LOADED")

-- Create a lookup table to store the translations
local LocaleTable = {
	-- Translations for the stranger
	["DeclinePlayerDuels_deDE"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_esES"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_esMX"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_frFR"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_itIT"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_koKR"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_ptBR"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_ruRU"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_zhCN"] = "Declined a duel request from: ",
	["DeclinePlayerDuels_zhTW"] = "Declined a duel request from: ",

	["DeclinePetDuels_deDE"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_esES"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_esMX"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_frFR"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_itIT"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_koKR"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_ptBR"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_ruRU"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_zhCN"] = "Declined a pet battle pvp duel request from:  ",
	["DeclinePetDuels_zhTW"] = "Declined a pet battle pvp duel request from:  ",

	-- Translations for the desc of the addon
	["TradeTargetInfo_deDE"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_esES"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_esMX"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_frFR"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_itIT"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_koKR"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_ptBR"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_ruRU"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_zhCN"] = "Automatically declines player and pet battle duels.",
	["TradeTargetInfo_zhTW"] = "Automatically declines player and pet battle duels.",
}

local DeclinePlayerDuels = LocaleTable["DeclinePlayerDuels_" .. GetLocale()] or "Declined a duel request from: "
local DeclinePetDuels = LocaleTable["DeclinePetDuels_" .. GetLocale()] or "Declined a pet battle pvp duel request from: "
local AutoDeclineDuelsInfo = LocaleTable["TradeTargetInfo_" .. GetLocale()] or "Automatically declines player and pet battle duels."

-- Cancels a pending duel request
function Module:DeclinePlayerDuels(name)
	if not name then
		name = UNKNOWN
	end

	CancelDuel() -- Call CancelDuel to cancel the request
	StaticPopup_Hide("DUEL_REQUESTED") -- Hides the pending duel popup
	print(DeclinePlayerDuels .. "|CFF669DFF" .. name .. "|r") -- Print confirmation message
end

-- Cancels a pending pet battle pvp duel request
function Module:DeclinePetDuels(name)
	if not name then
		name = UNKNOWN
	end

	C_PetBattles.CancelPVPDuel() -- Call C_PetBattles_CancelPVPDuel to cancel the request
	StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED") -- Hides the pending pet battle pvp duel popup
	print(DeclinePetDuels .. "|CFF669DFF" .. name .. "|r") -- Print confirmation message
end

function Module:UpdateDeclineDuels(event, enable)
	if enable then
		self:RegisterEvent(event)
		print("Registered event:", event)
	else
		self:UnregisterEvent(event)
		print("Unregistered event:", event)
	end
end

function Module:UpdatePlayerDeclineDuels()
	self:UpdateDeclineDuels("DUEL_REQUESTED", DeclineDuelsDB.player)
end

function Module:UpdatePetDeclineDuels()
	self:UpdateDeclineDuels("PET_BATTLE_PVP_DUEL_REQUESTED", DeclineDuelsDB.pet)
end

function Module:CreateDeclineDuelsOptions()
	-- Determine which options panel to use
	local optionsPanel = WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE and SettingsPanel.Container or InterfaceOptionsFramePanelContainer

	-- Define the default saved variable values
	local AutoDeclineDuelsDefaults = {
		-- Boolean indicating if the trade target info feature is enabled
		player = false,
		pet = false,
	}

	-- Create the saved variable or use the existing one
	DeclineDuelsDB = DeclineDuelsDB or CopyTable(AutoDeclineDuelsDefaults)

	-- Create the config panel frame
	self.ConfigPanel = CreateFrame("Frame")
	-- Set the name of the config panel to be displayed in the Interface Options
	self.ConfigPanel.name = "|cff669DFFDecline Duels|r"

	-- Create the scroll frame and position it within the panel
	local scrollFrame = CreateFrame("ScrollFrame", nil, self.ConfigPanel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 3, -6)
	scrollFrame:SetPoint("BOTTOMRIGHT", -27, 6)

	-- Create the scroll child frame and set its width to fit within the panel
	local scrollChild = CreateFrame("Frame")
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(optionsPanel:GetWidth() - 18)

	-- Set a minimum height for the scroll child frame
	scrollChild:SetHeight(1)

	-- Add widgets to the scrolling child frame as desired
	local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText(self.ConfigPanel.name)

	local description = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")
	description:SetPoint("TOP", 0, -26)
	description:SetText(AutoDeclineDuelsInfo)

	-- Create the Enable/Disable checkbox for the Thanks Module
	local PlayerCheckbox = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
	-- Set the position of the checkbox on the config panel
	PlayerCheckbox:SetPoint("TOPLEFT", 0, -80)
	-- Set the text of the checkbox
	PlayerCheckbox.Text:SetText(" Decline duels from player requests")
	-- Add an OnClick event to the checkbox
	PlayerCheckbox:SetScript("OnClick", function()
		-- Save the state of the checkbox to the saved variable TradeTargetInfoDB
		DeclineDuelsDB.player = PlayerCheckbox:GetChecked()

		-- Update the event registration based on the checkbox state
		self:UpdatePlayerDeclineDuels(DeclineDuelsDB.player)
	end)
	PlayerCheckbox:SetChecked(DeclineDuelsDB.player)

	-- Create the Enable/Disable checkbox for the Thanks Module
	local PetCheckbox = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
	-- Set the position of the checkbox on the config panel
	PetCheckbox:SetPoint("TOPLEFT", 0, -110)
	-- Set the text of the checkbox
	PetCheckbox.Text:SetText(" Decline duels from pet battle requests")
	-- Add an OnClick event to the checkbox
	PetCheckbox:SetScript("OnClick", function()
		-- Save the state of the checkbox to the saved variable TradeTargetInfoDB
		DeclineDuelsDB.pet = PetCheckbox:GetChecked()

		-- Update the event registration based on the checkbox state
		self:UpdatePetDeclineDuels(DeclineDuelsDB.pet)
	end)
	PetCheckbox:SetChecked(DeclineDuelsDB.pet)

	-- Add the config panel to the Interface Options
	InterfaceOptions_AddCategory(self.ConfigPanel)
end

-- Function to handle events
Module:SetScript("OnEvent", function(self, event, arg1)
	-- Check if the event is "PLAYER_LOGIN"
	if event == "VARIABLES_LOADED" then
		-- Call the functions to create the options panel and unregister the event
		self:CreateDeclineDuelsOptions()
		self:UnregisterEvent(event)
	elseif event == "DUEL_REQUESTED" then
		self:DeclinePlayerDuels(arg1)
	elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" then
		self:DeclinePetDuels(arg1)
	end
end)

-- Define the slash commands for opening the options panel
SLASH_AUTODECLINEDUELSINFO1 = "/adds"
SLASH_AUTODECLINEDUELSINFO2 = "/autoseclinesuels"
SlashCmdList.AUTODECLINEDUELSINFO = function()
	-- Open the options panel to the "Module.ConfigPanel" category
	InterfaceOptionsFrame_OpenToCategory(Module.ConfigPanel)
end
