if SlacksTechies == nil then
	_G.SlacksTechies = class({})
end

require("precache")
require("timers")
require("cosmetics_setup")

function Precache( context )
	for _,Item in pairs( g_ItemPrecache ) do
    	PrecacheItemByNameSync( Item, context )
    end

	for _,Model in pairs( g_ModelPrecache ) do
		PrecacheResource( "model", Model, context )
	end

	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context )
	end

	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end

	for _,Unit in pairs( g_UnitPrecache ) do
    	PrecacheUnitByNameAsync( Unit, function( unit ) end )
  	end
	PrecacheResource("particle_folder", "particles/econ/items/pudge/pudge_arcana", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_antimage_female", context)
	PrecacheResource("model_folder", "models/heroes/antimage_female", context)
	PrecacheResource("model_folder", "models/items/pudge/arcana", context)
	PrecacheResource("particle_folder", "particles/econ/items/juggernaut/jugg_arcana", context)
	PrecacheResource("model_folder", "models/heroes/juggernaut", context)
	PrecacheResource("particle_folder", "particles/econ/items/earthshaker/earthshaker_arcana", context)
	PrecacheResource("model_folder", "models/items/earthshaker/earthshaker_arcana", context)
	PrecacheResource("particle_folder", "particles/econ/items/zeus/arcana_chariot", context)
	PrecacheResource("model_folder", "models/heroes/zeus", context)
	PrecacheResource("particle_folder", "particles/econ/items/wisp", context)
	PrecacheResource("model_folder", "models/items/io/io_ti7", context)
	PrecacheResource("particle_folder", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith", context)
	PrecacheResource("model_folder", "models/heroes/phantom_assassin", context)
	PrecacheResource("particle_folder", "particles/econ/items/lina/lina_head_headflame", context)
	PrecacheResource("model_folder", "models/heroes/invoker_kid", context)
	PrecacheResource("model_folder", "models/items/wraith_king/arcana", context)
	PrecacheResource("model_folder", "models/heroes/attachto_ghost", context)
	PrecacheResource("model_folder", "models/heroes/crystal_maiden_persona", context)
	PrecacheResource("model_folder", "models/heroes/dragon_knight_persona", context)
	PrecacheResource("model_folder", "models/heroes/invoker_kid", context)
	PrecacheResource("model_folder", "models/heroes/mirana_persona", context)
	PrecacheResource("model_folder", "models/heroes/phantom_assassin_persona", context)
	PrecacheResource("model_folder", "models/heroes/pudge_cute", context)
	PrecacheResource("model_folder", "models/heroes/shopkeeper", context)
	PrecacheResource("model_folder", "models/heroes/shopkeeper_dire", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_crystalmaiden_persona", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_invoker_kid", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_phantom_assassin_persona", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_pudge_cute", context)
	PrecacheResource("particle_folder", "particles/base_attacks", context)
	PrecacheResource("particle_folder", "particles/neutral_fx", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_techies", context)
	PrecacheResource("particle_folder", "particles/generic_gameplay", context)
	PrecacheResource("particle_folder", "particles/generic_hero_status", context)
	PrecacheResource("particle_folder", "particles/items_fx", context)
	PrecacheResource("particle_folder", "particles/items2_fx", context)
	PrecacheResource("particle_folder", "particles/items3_fx", context)
	PrecacheResource("particle_folder", "particles/items4_fx", context)
	PrecacheResource("particle_folder", "particles/items5_fx", context)
	PrecacheResource("particle_folder", "particles/items6_fx", context)
	PrecacheResource("particle_folder", "particles/items7_fx", context)
	PrecacheResource("particle_folder", "particles/items8_fx", context)
	PrecacheResource("particle_folder", "particles/items_4fx", context)
end

function Activate()
	GameRules.SlacksTechies = SlacksTechies()
	GameRules.SlacksTechies:InitGameMode()
	SendToServerConsole("tv_delay 0")
end

function SlacksTechies:InitGameMode()
	SlacksTechies.TechiesVotes = SlacksTechies.TechiesVotes or {}
	SlacksTechies.AbilityVotes = SlacksTechies.AbilityVotes or {}
	SlacksTechies.RedMines = SlacksTechies.RedMines or {}
	MAX_TEAMS = 2   
	PLAYER_COUNT = {}        
	PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5
	PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5

	local count = 0
	for team,number in pairs(PLAYER_COUNT) do
		if count >= MAX_TEAMS then
			GameRules:SetCustomGameTeamMaxPlayers(team, 0)
		else
			GameRules:SetCustomGameTeamMaxPlayers(team, number)
		end
		count = count + 1
	end

	GameRules:SetSameHeroSelectionEnabled(false)
	GameRules:SetShowcaseTime(0)
	GameRules:SetCustomGameAllowMusicAtGameStart(false)
	GameRules:SetCustomGameAllowBattleMusic(false)
	GameRules:SetCustomGameAllowHeroPickMusic(false)

	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetUseDefaultDOTARuneSpawnLogic(true)
	GameMode:SetTowerBackdoorProtectionEnabled(true)
	GameMode:SetFreeCourierModeEnabled(true)
	GameMode:SetUseTurboCouriers(false)
	GameMode:DisableHudFlip(true)
	GameMode:SetKillingSpreeAnnouncerDisabled(true)

	ListenToGameEvent("npc_spawned", Dynamic_Wrap(SlacksTechies, "OnNPCSpawned"), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( SlacksTechies, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap(SlacksTechies, 'OnEntityKilled'), self)
	CustomGameEventManager:RegisterListener("detonate_selected_mines", Dynamic_Wrap(SlacksTechies, "OnDetonateSelectedMines"))
	CustomGameEventManager:RegisterListener("vote_option_clicked", Dynamic_Wrap(SlacksTechies, "OnVoteOptionClicked"))
end

function SlacksTechies:OnNPCSpawned(event)
	local unit = EntIndexToHScript(event.entindex)
	
	if unit and not unit:IsNull() and unit:GetUnitName() == "npc_dota_techies_custom_remote_mine" then
		local remote = unit:FindAbilityByName("custom_techies_remote_mine_self_detonate")
		if remote and remote:GetLevel() < 1 then remote:SetLevel(1) end
	end

	if unit and not unit:IsNull() and unit:IsRealHero() and unit.bFirstSpawned == nil then
		unit.bFirstSpawned = true
		Timers:CreateTimer(0.1, function()
			if unit and not unit:IsNull() then
				if SlacksTechies.BlastOffSwapped then
					if unit:HasAbility("custom_techies_suicide12") then
						unit:RemoveAbility("custom_techies_suicide12")
						unit:RemoveAbility("special_bonus_unique_techies_15_r")
						unit:RemoveAbility("special_bonus_unique_techies_20_l")
						local newAbility = unit:AddAbility("custom_techies_suicide_old")
						local newTalent = unit:AddAbility("special_bonus_unique_techies_15_r_old")
						local newTalent2 = unit:AddAbility("special_bonus_unique_techies_20_l_old")
					end
				end

				if SlacksTechies.RedMinesSwapped then
					if unit:HasAbility("custom_techies_land_mines") then
						unit:RemoveAbility("custom_techies_land_mines")
						unit:AddAbility("custom_techies_land_mines_old")
					end
				end

				local sign = unit:FindAbilityByName("custom_techies_minefield_sign")
				if sign and sign:GetLevel() < 1 then sign:SetLevel(1) end

				local innate = unit:FindAbilityByName("custom_techies_mana_innate")
				if innate and innate:GetLevel() < 1 then innate:SetLevel(1) end
			end
		end)
	end
end

function SlacksTechies:OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed)
    if not killed or killed:IsNull() then return end
    if not killed:IsRealHero() then return end

    local inflictor = event.entindex_inflictor and EntIndexToHScript(event.entindex_inflictor)
    if inflictor and inflictor.GetAbilityName and inflictor:GetAbilityName() == "custom_techies_suicide_old" then
        if killed == inflictor:GetCaster() then
            Timers:CreateTimer(0.1, function()
                if killed and not killed:IsNull() then
                    local rt = killed:GetRespawnTime()
                    killed:SetTimeUntilRespawn(rt * 0.5)
                end
            end)
        end
    end
end

function SlacksTechies:OnDetonateSelectedMines(event)
    DeepPrintTable(event)
    
    local pid = event.PlayerID
    if not event.entities then 
        return 
    end
    
    local count = 0
    for k, entindex in pairs(event.entities) do
        count = count + 1
        local mine = EntIndexToHScript(entindex)
        if mine and not mine:IsNull() then
            if mine:GetUnitName() == "npc_dota_techies_custom_remote_mine" and mine:GetPlayerOwnerID() == pid then
                local mod = mine:FindModifierByName("modifier_custom_techies_remote_mine")
                if mod then 
                    mod:Detonate() 
                end
            end
        end
    end
end

function SlacksTechies:OnGameRulesStateChange()
  local nNewState = GameRules:State_Get()
  if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
	SlacksTechies:EvaluateTechiesVote()
	SlacksTechies:EvaluateAbilityVote()
	SlacksTechies:EvaluateRedMinesVote()
  elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
    print( "DOTA_GAMERULES_STATE_PRE_GAME" )
    SlacksTechies:OnGamePreGame()
  elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    print( "DOTA_GAMERULES_STATE_GAME_IN_PROGRESS" )
  end
end

function SlacksTechies:OnGamePreGame()
    Timers:CreateTimer(5, function()
		for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(playerID) then
				local sID = PlayerResource:GetSteamAccountID(playerID)
				if sID then
					local player = PlayerResource:GetPlayer(playerID)
					local hero = player and player:GetAssignedHero()
					if hero then
						AssignCosmetics(sID, hero)
						print( "[Cosmetics] Assigned Cosmetics" )
					end
				end
			end
		end
		return
	end)
end

function SlacksTechies.OnVoteOptionClicked(eventSourceIndex, data)
    local playerID = data.playerID
    local option = data.option
    local value = (data.value == 1 or data.value == true)

    if option == "force_techies" then
        SlacksTechies.TechiesVotes[playerID] = value
        local yesVotes = 0
        for pID, wantsTechies in pairs(SlacksTechies.TechiesVotes) do
            if wantsTechies then
                yesVotes = yesVotes + 1
            end
        end
        CustomGameEventManager:Send_ServerToAllClients("update_vote_label", {
            option = option,
            votes = yesVotes,
            playerCount = PlayerResource:GetPlayerCount()
        })
    elseif option == "swap_blast_off" then
        SlacksTechies.AbilityVotes[playerID] = value
        local yesVotes = 0
        for pID, wantsSwap in pairs(SlacksTechies.AbilityVotes) do
            if wantsSwap then
                yesVotes = yesVotes + 1
            end
        end
        CustomGameEventManager:Send_ServerToAllClients("update_vote_label", {
            option = option,
            votes = yesVotes,
            playerCount = PlayerResource:GetPlayerCount()
        })
	elseif option == "swap_red_mines" then
        SlacksTechies.RedMines[playerID] = value
        local yesVotes = 0
        for pID, wantsSwap in pairs(SlacksTechies.RedMines) do
            if wantsSwap then
                yesVotes = yesVotes + 1
            end
        end
        CustomGameEventManager:Send_ServerToAllClients("update_vote_label", {
            option = option,
            votes = yesVotes,
            playerCount = PlayerResource:GetPlayerCount()
        })
    end
end

function SlacksTechies:EvaluateTechiesVote()
    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.TechiesVotes then
        for playerID, wantsTechies in pairs(SlacksTechies.TechiesVotes) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsTechies then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
        GameRules:SetSameHeroSelectionEnabled(true)
        Timers:CreateTimer(0.1, function()
            for pID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
                if PlayerResource:IsValidPlayerID(pID) and PlayerResource:IsValidPlayer(pID) then
                    local player = PlayerResource:GetPlayer(pID)
                    if player then
                        player:SetSelectedHero("npc_dota_hero_techies")
                    end
                end
            end
            GameRules:SetHeroSelectionTime(0)
        end)
    end
end

function SlacksTechies:EvaluateAbilityVote()
    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.AbilityVotes then
        for playerID, wantsSwap in pairs(SlacksTechies.AbilityVotes) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsSwap then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
        SlacksTechies.BlastOffSwapped = true
    else
        SlacksTechies.BlastOffSwapped = false
    end
end

function SlacksTechies:EvaluateRedMinesVote()
    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.RedMines then
        for playerID, wantsSwap in pairs(SlacksTechies.RedMines) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsSwap then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
        SlacksTechies.RedMinesSwapped = true
    else
        SlacksTechies.RedMinesSwapped = false
    end
end