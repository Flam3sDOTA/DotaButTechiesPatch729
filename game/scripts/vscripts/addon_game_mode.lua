if SlacksTechies == nil then
	_G.SlacksTechies = class({})
end

require("precache")
require("timers")

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

	for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
		PrecacheResource( "particle_folder", Particle, context )
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
end

function Activate()
	GameRules.SlacksTechies = SlacksTechies()
	GameRules.SlacksTechies:InitGameMode()
	SendToServerConsole("tv_delay 0")
end

function SlacksTechies:InitGameMode()
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
	CustomGameEventManager:RegisterListener("detonate_selected_mines", Dynamic_Wrap(SlacksTechies, "OnDetonateSelectedMines"))
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(SlacksTechies, "FilterExecuteOrder"), self)
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
				local sign = unit:FindAbilityByName("custom_techies_minefield_sign")
				if sign and sign:GetLevel() < 1 then sign:SetLevel(1) end

				local innate = unit:FindAbilityByName("custom_techies_mana_innate")
				if innate and innate:GetLevel() < 1 then innate:SetLevel(1) end
			end
		end)
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

function SlacksTechies:FilterExecuteOrder(event)
    if event.order_type ~= DOTA_UNIT_ORDER_CAST_POSITION then return true end
    
    local ability = event.entindex_ability and event.entindex_ability ~= 0 and EntIndexToHScript(event.entindex_ability) or nil
    if not ability or ability:GetAbilityName() ~= "item_tpscroll" then return true end
    
    local MINE_NAMES = {
        ["npc_dota_techies_land_mine_custom"]   = true,
        ["npc_dota_techies_stasis_trap"]        = true,
        ["npc_dota_techies_custom_remote_mine"] = true,
        ["npc_dota_techies_custom_sign"]        = true,
    }
    
    local pos = Vector(event.position_x, event.position_y, event.position_z)
    local caster_unit = event.units and event.units["0"] and EntIndexToHScript(event.units["0"]) or nil
    if not caster_unit then return true end
    local team = caster_unit:GetTeamNumber()
    
    local friendlies = FindUnitsInRadius(
        team, pos, nil, 25000,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
        FIND_CLOSEST, false)
    
    for _, u in pairs(friendlies) do
        if u and not u:IsNull() and u ~= caster_unit then
            if MINE_NAMES[u:GetUnitName()] then
                local buildings = FindUnitsInRadius(
                    team, pos, nil, 900,
                    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                    DOTA_UNIT_TARGET_BUILDING,
                    DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                    FIND_ANY_ORDER, false)
                if #buildings > 0 then
                    return true
                end
                return false
            else
                break
            end
        end
    end
    
    return true
end