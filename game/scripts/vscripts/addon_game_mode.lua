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

	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetUseDefaultDOTARuneSpawnLogic(true)
	GameMode:SetTowerBackdoorProtectionEnabled(true)
	GameMode:SetFreeCourierModeEnabled(true)
	GameMode:SetUseTurboCouriers(false)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(SlacksTechies, "OnNPCSpawned"), self)
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
				
			end
		end)
	end
end
