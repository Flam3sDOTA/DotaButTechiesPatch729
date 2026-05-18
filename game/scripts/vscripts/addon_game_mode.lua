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
	PrecacheResource("particle_folder", "particles/units/heroes/hero_abaddon", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_axe", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_bane", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_bloodseeker", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_crystalmaiden", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_crystalmaiden_persona", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_drow", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_earthshaker", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_juggernaut", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_mirana", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_morphling", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_nevermore", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_phantom_lancer", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_puck", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_pudge", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_pudge_cute", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_razor", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_razor_reduced_flash", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_sandking", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_stormspirit", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_sven", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_tiny", context)
end

function Activate()
	GameRules.SlacksTechies = SlacksTechies()
	GameRules.SlacksTechies:InitGameMode()
	SendToServerConsole("tv_delay 0")
end

function SlacksTechies:InitGameMode()
	SlacksTechies.TechiesVotes = SlacksTechies.TechiesVotes or {}
	SlacksTechies.RandomTechiesVotes = SlacksTechies.RandomTechiesVotes or {}
	SlacksTechies.AbilityVotes = SlacksTechies.AbilityVotes or {}
	SlacksTechies.RedMines = SlacksTechies.RedMines or {}
	SlacksTechies.Bots = SlacksTechies.Bots or {}
	SlacksTechies.Turbo = SlacksTechies.Turbo or {}
	SlacksTechies.FullTurbo = SlacksTechies.FullTurbo or {}

	voteOptionsText = {}
	voteOptionsText["force_techies"] = "Force Everyone Techies"
	voteOptionsText["random_techies"] = "Random Player Gets Techies"
	voteOptionsText["turbo_mode"] = "Turbo XP + Gold"
	voteOptionsText["turbo_mode_full"] = "Full Turbo Mode"
	voteOptionsText["swap_blast_off"] = "Old Suicide Squad, Attack!"
	voteOptionsText["swap_red_mines"] = "Red Mines: Increased Damage, But Can't Stack"
	voteOptionsText["fill_bots"] = "Fill Empty Slots With Bots"

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
	GameRules:SetCustomGameSetupAutoLaunchDelay(60)

	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetUseDefaultDOTARuneSpawnLogic(true)
	GameMode:SetTowerBackdoorProtectionEnabled(true)
	GameMode:SetFreeCourierModeEnabled(true)
	GameMode:SetUseTurboCouriers(false)
	GameMode:DisableHudFlip(true)
	GameMode:SetKillingSpreeAnnouncerDisabled(true)
	GameMode:SetForcedHUDSkin( "the_international_2024" )

	ListenToGameEvent("npc_spawned", Dynamic_Wrap(SlacksTechies, "OnNPCSpawned"), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( SlacksTechies, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap(SlacksTechies, 'OnEntityKilled'), self)
	CustomGameEventManager:RegisterListener("detonate_selected_mines", Dynamic_Wrap(SlacksTechies, "OnDetonateSelectedMines"))
	CustomGameEventManager:RegisterListener("vote_option_clicked", Dynamic_Wrap(SlacksTechies, "OnVoteOptionClicked"))
end

function SlacksTechies:OnNPCSpawned(event)
	local unit = EntIndexToHScript(event.entindex)

	if SlacksTechies.FullTurboMode and unit and not unit:IsNull() then
		local TURBO_CREEP_STATS = {
			["npc_dota_goodguys_siege_upgraded_mega"]            = { hp = 1870, dmgMin = 102, dmgMax = 124 },
			["npc_dota_creep_goodguys_ranged_upgraded_mega"]     = { hp = 950,  dmgMin = 92,  dmgMax = 102 },
			["npc_dota_creep_goodguys_melee_upgraded_mega"]      = { hp = 1400, dmgMin = 82,  dmgMax = 98  },
			["npc_dota_creep_goodguys_flagbearer_upgraded_mega"] = { hp = 1400, dmgMin = 82,  dmgMax = 98  },
			["npc_dota_badguys_siege_upgraded_mega"]             = { hp = 1870, dmgMin = 102, dmgMax = 124 },
			["npc_dota_creep_badguys_ranged_upgraded_mega"]      = { hp = 950,  dmgMin = 92,  dmgMax = 102 },
			["npc_dota_creep_badguys_melee_upgraded_mega"]       = { hp = 1400, dmgMin = 82,  dmgMax = 98  },
			["npc_dota_creep_badguys_flagbearer_upgraded_mega"]  = { hp = 1400, dmgMin = 82,  dmgMax = 98  },
		}
		local stats = TURBO_CREEP_STATS[unit:GetUnitName()]
		if stats then
			Timers:CreateTimer(0.1, function()
				unit:SetMaxHealth(stats.hp)
				unit:SetHealth(stats.hp)
				unit:SetBaseDamageMin(stats.dmgMin)
				unit:SetBaseDamageMax(stats.dmgMax)
			end)
		end
	end
	
	if unit and not unit:IsNull() and unit:GetUnitName() == "npc_dota_techies_custom_remote_mine" then
		local remote = unit:FindAbilityByName("custom_techies_remote_mine_self_detonate")
		if remote and remote:GetLevel() < 1 then remote:SetLevel(1) end
	end

	if unit and not unit:IsNull() and unit:IsRealHero() and unit.bFirstSpawned == nil then
		unit.bFirstSpawned = true
		Timers:CreateTimer(0.3, function()
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

				if SlacksTechies.FillBots then
					Timers:CreateTimer(1, function()
						SendToServerConsole('sv_cheats 1')
						Convars:SetBool('dota_bot_mode', true)
						Convars:SetBool('dota_bot_disable', false)
						Convars:SetInt('dota_bot_set_difficulty', 4)
						Convars:SetInt('dota_bot_practice_difficulty', 4)
						GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)

						local heroPool = {
							"npc_dota_hero_abaddon",
							"npc_dota_hero_lina",
							"npc_dota_hero_axe",
							"npc_dota_hero_bane",
							"npc_dota_hero_bloodseeker",
							"npc_dota_hero_crystal_maiden",
							"npc_dota_hero_drow_ranger",
							"npc_dota_hero_earthshaker",
							"npc_dota_hero_juggernaut",
							"npc_dota_hero_mirana",
							"npc_dota_hero_nevermore",
							"npc_dota_hero_morphling",
							"npc_dota_hero_phantom_lancer",
							"npc_dota_hero_puck",
							"npc_dota_hero_pudge",
							"npc_dota_hero_razor",
							"npc_dota_hero_sand_king",
							"npc_dota_hero_storm_spirit",
							"npc_dota_hero_sven",
							"npc_dota_hero_tiny"
						}

						local pickedHeroes = {}
						for id = 0, 24 do
							if PlayerResource:IsValidPlayerID(id) then
								local heroName = PlayerResource:GetSelectedHeroName(id)
								if heroName and heroName ~= "" then
									pickedHeroes[heroName] = true
								end
							end
						end

						local availableHeroes = {}
						for _, heroName in ipairs(heroPool) do
							if not pickedHeroes[heroName] then
								table.insert(availableHeroes, heroName)
							end
						end

						for i = #availableHeroes, 2, -1 do
							local j = RandomInt(1, i)
							availableHeroes[i], availableHeroes[j] = availableHeroes[j], availableHeroes[i]
						end

						local radiantSlots = 5 - PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
						for i = 1, radiantSlots do
							if #availableHeroes > 0 then
								local botHero = table.remove(availableHeroes, 1)
								Tutorial:AddBot(botHero, '', 'unfair', true)
							end
						end

						local direSlots = 5 - PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
						for i = 1, direSlots do
							if #availableHeroes > 0 then
								local botHero = table.remove(availableHeroes, 1)
								Tutorial:AddBot(botHero, '', 'unfair', false)
							end
						end
					end)
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
	print( "DOTA_GAMERULES_STATE_HERO_SELECTION" )
	SlacksTechies:EvaluateTechiesVote()
	SlacksTechies:EvaluateRandomTechiesVote()
	SlacksTechies:EvaluateAbilityVote()
	SlacksTechies:EvaluateRedMinesVote()
	SlacksTechies:EvaluateBots()
	SlacksTechies:EvaluateFullTurbo()
	SlacksTechies:EvaluateTurbo()
  elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
    print( "DOTA_GAMERULES_STATE_PRE_GAME" )
    local results = {
		{ text = voteOptionsText["force_techies"],   active = SlacksTechies.ForceTechiesMode  },
		{ text = voteOptionsText["random_techies"],  active = SlacksTechies.RandomTechiesMode },
		{ text = voteOptionsText["turbo_mode"],      active = SlacksTechies.TurboMode         },
		{ text = voteOptionsText["turbo_mode_full"], active = SlacksTechies.FullTurboMode     },
		{ text = voteOptionsText["swap_blast_off"],  active = SlacksTechies.BlastOffSwapped   },
		{ text = voteOptionsText["swap_red_mines"],  active = SlacksTechies.RedMinesSwapped   },
		{ text = voteOptionsText["fill_bots"],       active = SlacksTechies.FillBots          },
	}
    for _, result in ipairs(results) do
        if result.active then
            GameRules:SendCustomMessage("<b color='LawnGreen'>[ACTIVE]: </b><b color='white'>" .. result.text .. "</b>", 0, 0)
        else
            GameRules:SendCustomMessage("<b color='red'>[DISABLED]: </b><b color='white'>" .. result.text .. "</b>", 0, 0)
        end
    end
    SlacksTechies:OnGamePreGame()
  elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    print( "DOTA_GAMERULES_STATE_GAME_IN_PROGRESS" )
  end
end

function SlacksTechies:OnGamePreGame()
	if SlacksTechies.FullTurboMode then
		Timers:CreateTimer(0.1, function()
			local TURBO_BUILDING_STATS = {
				["npc_dota_goodguys_fort"] = { regen = 0 },
				["npc_dota_badguys_fort"]  = { regen = 0 },
				["npc_dota_goodguys_tower1_top"] = { hp = 1350, armor = 9 },
				["npc_dota_goodguys_tower1_mid"] = { hp = 1350, armor = 9 },
				["npc_dota_goodguys_tower1_bot"] = { hp = 1350, armor = 9 },
				["npc_dota_badguys_tower1_top"]  = { hp = 1350, armor = 9 },
				["npc_dota_badguys_tower1_mid"]  = { hp = 1350, armor = 9 },
				["npc_dota_badguys_tower1_bot"]  = { hp = 1350, armor = 9 },
				["npc_dota_goodguys_tower2_top"] = { hp = 2500, armor = 16 },
				["npc_dota_goodguys_tower2_mid"] = { hp = 2500, armor = 16 },
				["npc_dota_goodguys_tower2_bot"] = { hp = 2500, armor = 16 },
				["npc_dota_badguys_tower2_top"]  = { hp = 2500, armor = 16 },
				["npc_dota_badguys_tower2_mid"]  = { hp = 2500, armor = 16 },
				["npc_dota_badguys_tower2_bot"]  = { hp = 2500, armor = 16 },
				["npc_dota_goodguys_tower3_top"] = { hp = 2500, armor = 16 },
				["npc_dota_goodguys_tower3_mid"] = { hp = 2500, armor = 16 },
				["npc_dota_goodguys_tower3_bot"] = { hp = 2500, armor = 16 },
				["npc_dota_badguys_tower3_top"]  = { hp = 2500, armor = 16 },
				["npc_dota_badguys_tower3_mid"]  = { hp = 2500, armor = 16 },
				["npc_dota_badguys_tower3_bot"]  = { hp = 2500, armor = 16 },
				["npc_dota_goodguys_tower4"]     = { hp = 2600, armor = 21 },
				["npc_dota_badguys_tower4"]      = { hp = 2600, armor = 21 },
			}
			
			local allUnits = FindUnitsInRadius(
				DOTA_TEAM_NEUTRALS,
				Vector(0, 0, 0),
				nil,
				25000,
				DOTA_UNIT_TARGET_TEAM_BOTH,
				DOTA_UNIT_TARGET_ALL,
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
				FIND_ANY_ORDER,
				false
			)

			for _, ent in ipairs(allUnits) do
				if ent and not ent:IsNull() then
					local stats = TURBO_BUILDING_STATS[ent:GetUnitName()]
					if stats then
						if stats.regen ~= nil then ent:SetBaseHealthRegen(stats.regen) end
						if stats.hp then ent:SetMaxHealth(stats.hp) ent:SetHealth(stats.hp) end
						if stats.armor then ent:SetPhysicalArmorBaseValue(stats.armor) end
					end
				end
			end
		end)
	end

    Timers:CreateTimer(4, function()
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
	elseif option == "random_techies" then
		SlacksTechies.RandomTechiesVotes[playerID] = value
		local yesVotes = 0
		for pID, v in pairs(SlacksTechies.RandomTechiesVotes) do
			if v then yesVotes = yesVotes + 1 end
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
    elseif option == "fill_bots" then
        SlacksTechies.Bots[playerID] = value
        local yesVotes = 0
        for pID, wantsSwap in pairs(SlacksTechies.Bots) do
            if wantsSwap then
                yesVotes = yesVotes + 1
            end
        end
        CustomGameEventManager:Send_ServerToAllClients("update_vote_label", {
            option = option,
            votes = yesVotes,
            playerCount = PlayerResource:GetPlayerCount()
        })
    elseif option == "turbo_mode" then
        SlacksTechies.Turbo[playerID] = value
        local yesVotes = 0
        for pID, wantsSwap in pairs(SlacksTechies.Turbo) do
            if wantsSwap then
                yesVotes = yesVotes + 1
            end
        end
        CustomGameEventManager:Send_ServerToAllClients("update_vote_label", {
            option = option,
            votes = yesVotes,
            playerCount = PlayerResource:GetPlayerCount()
        })
    elseif option == "turbo_mode_full" then
        SlacksTechies.FullTurbo[playerID] = value
        local yesVotes = 0
        for pID, wantsSwap in pairs(SlacksTechies.FullTurbo) do
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
		SlacksTechies.ForceTechiesMode = true
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
            GameRules:SetHeroSelectionTime(1)
        end)
	else
        SlacksTechies.ForceTechiesMode = false
    end
end

function SlacksTechies:EvaluateRandomTechiesVote()
	if SlacksTechies.ForceTechiesMode then
		return
	end
    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.RandomTechiesVotes then
        for playerID, wantsTechies in pairs(SlacksTechies.RandomTechiesVotes) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsTechies then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
		SlacksTechies.RandomTechiesMode = true
		local validIDs = {}
		for pID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            if PlayerResource:IsValidPlayerID(pID) and PlayerResource:IsValidPlayer(pID) then
                table.insert(validIDs, pID)
            end
        end
        if #validIDs > 0 then
            local chosen = validIDs[RandomInt(1, #validIDs)]
            Timers:CreateTimer(0.1, function()
                local player = PlayerResource:GetPlayer(chosen)
                if player then
                    player:SetSelectedHero("npc_dota_hero_techies")
				 	Timers:CreateTimer(0.1, function()
						Say(PlayerResource:GetPlayer(chosen), "Has randomed Techies", false)
					 end)
                end
            end)
        end
	else
		SlacksTechies.RandomTechiesMode = false
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

function SlacksTechies:EvaluateBots()
    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.Bots then
        for playerID, wantsSwap in pairs(SlacksTechies.Bots) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsSwap then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
        SlacksTechies.FillBots = true
    else
        SlacksTechies.FillBots = false
    end
end

function SlacksTechies:EvaluateFullTurbo()
    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.FullTurbo then
        for playerID, wantsSwap in pairs(SlacksTechies.FullTurbo) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsSwap then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
        SlacksTechies.FullTurboMode = true
		local GameMode = GameRules:GetGameModeEntity()
		GameRules:SetFilterMoreGold(true)
		GameRules:SetUseUniversalShopMode(true)
		GameMode:SetCanSellAnywhere(true)
		GameMode:SetUseTurboCouriers(true)
		GameMode:SetModifyGoldFilter(Dynamic_Wrap(SlacksTechies, "OnModifyGold"), self)
		GameMode:SetModifyExperienceFilter(Dynamic_Wrap(SlacksTechies, "OnModifyExperience"), self)
		GameMode:SetBountyRunePickupFilter(Dynamic_Wrap(SlacksTechies, "OnBountyRunePickup"), self)
		ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(SlacksTechies, 'OnPlayerUsedAbility'), self)
		Timers:CreateTimer(240, function()
			-- Add a stock of Infused Raindrops at 1:30 
			GameRules:SetItemStockCount(5, DOTA_TEAM_GOODGUYS, "item_infused_raindrop", -1)
			GameRules:SetItemStockCount(5, DOTA_TEAM_BADGUYS, "item_infused_raindrop", -1)
		end)

		Timers:CreateTimer(600, function()
			-- Add a stock of Aghanim Shard at 7:30 
			GameRules:SetItemStockCount(5, DOTA_TEAM_GOODGUYS, "item_aghanims_shard", -1)
			GameRules:SetItemStockCount(5, DOTA_TEAM_BADGUYS, "item_aghanims_shard", -1)
		end)
    else
        SlacksTechies.FullTurboMode = false
    end
end

function SlacksTechies:EvaluateTurbo()
	if SlacksTechies.FullTurboMode then
		SlacksTechies.TurboMode = false
		return
	end

    local activePlayers = PlayerResource:GetNumConnectedHumanPlayers()
    local yesVotes = 0
    
    if SlacksTechies.Turbo then
        for playerID, wantsSwap in pairs(SlacksTechies.Turbo) do
            local pID = tonumber(playerID)
            if pID and PlayerResource:IsValidPlayerID(pID) and PlayerResource:GetConnectionState(pID) == DOTA_CONNECTION_STATE_CONNECTED then
                if wantsSwap then
                    yesVotes = yesVotes + 1
                end
            end
        end
    end
    
    if yesVotes > (activePlayers / 2) then
        SlacksTechies.TurboMode = true
		local GameMode = GameRules:GetGameModeEntity()
		GameRules:SetFilterMoreGold(true)
		GameMode:SetModifyGoldFilter(Dynamic_Wrap(SlacksTechies, "OnModifyGold"), self)
		GameMode:SetModifyExperienceFilter(Dynamic_Wrap(SlacksTechies, "OnModifyExperience"), self)
		GameMode:SetBountyRunePickupFilter(Dynamic_Wrap(SlacksTechies, "OnBountyRunePickup"), self)
    else
        SlacksTechies.TurboMode = false
    end
end

local TURBO_GOLD_REASONS = {
    [DOTA_ModifyGold_GameTick] = true,       -- +2 GPM
    [DOTA_ModifyGold_Building] = false,      
    [DOTA_ModifyGold_HeroKill] = true,       -- Hero kills
    [DOTA_ModifyGold_CreepKill] = true,      -- Lane creeps, Siege, Mega, and Summons
    [DOTA_ModifyGold_RoshanKill] = false,    -- Roshan
    [DOTA_ModifyGold_CourierKill] = true,    -- Couriers
    [DOTA_ModifyGold_SharedGold] = false,     -- Team shared gold
    [DOTA_ModifyGold_NeutralKill] = true,       
    [DOTA_ModifyGold_AbilityGold] = true,    -- Hand of Midas, Track, etc.
    [DOTA_ModifyGold_WardKill] = true,       -- Wards
    [DOTA_ModifyGold_CourierKilledByThisPlayer] = true,
}

function SlacksTechies:OnModifyGold(event)
    local playerID = event.player_id_const
    if playerID == nil then return true end
    local reason = event.reason_const

    if TURBO_GOLD_REASONS[reason] then
		event.gold = event.gold * 2
	end

	-- No gold loss on death
    if reason == DOTA_ModifyGold_Death then
        return false 
    end

    return true
end

function SlacksTechies:OnBountyRunePickup(event)
    	event.gold_bounty = event.gold_bounty * 2
    return true
end

function SlacksTechies:OnModifyExperience(event)
    local playerID = event.player_id_const
    if playerID == nil then return true end

    event.experience = event.experience * 2
    return true
end

function SlacksTechies:OnPlayerUsedAbility(event)
    local playerID = event.PlayerID
    if playerID == nil then return end

    local abilityName = event.abilityname
    if abilityName ~= "item_tpscroll" and abilityName ~= "item_travel_boots" and abilityName ~= "item_travel_boots_2" then return end

    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    if not hero then return end

    local item = hero:FindItemInInventory(abilityName)
    if not item then return end

    Timers:CreateTimer(0.03, function()
        if item and IsValidEntity(item) then
            item:EndCooldown()
            item:StartCooldown(item:GetCooldown(item:GetLevel()) * 0.5)
        end
    end)
end