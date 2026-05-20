custom_techies_land_mines_old = class({})
LinkLuaModifier("modifier_custom_techies_land_mine_old", "modifiers/modifier_custom_techies_land_mine_old", LUA_MODIFIER_MOTION_NONE)

function custom_techies_land_mines_old:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function custom_techies_land_mines_old:CastFilterResultLocation(point)
    if not IsServer() then return UF_SUCCESS end

    local caster   = self:GetCaster()
    local min_dist = self:GetSpecialValueFor("min_plant_distance")

    local nearby = FindUnitsInRadius(
        caster:GetTeamNumber(), point, nil, min_dist,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER, false
    )
    for _, m in pairs(nearby) do
        if m and not m:IsNull()
            and m:GetUnitName() == "npc_dota_techies_land_mine_custom" then
            return UF_FAIL_CUSTOM
        end
    end
    return UF_SUCCESS
end

function custom_techies_land_mines_old:GetCustomCastErrorLocation(point)
    return "#custom_techies_land_mines_old_too_close"
end

function custom_techies_land_mines_old:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    if not caster or not point then return end
    local mine = CreateUnitByName("npc_dota_techies_land_mine_custom", point, true, caster, caster, caster:GetTeamNumber())
    mine:SetControllableByPlayer(caster:GetPlayerID(), true)
    local mine_modifier = mine:AddNewModifier(caster, self, "modifier_custom_techies_land_mine_old", {})
    local talent = caster:FindAbilityByName("special_bonus_unique_techies_25_l")
    if talent and talent:GetLevel() > 0 then
        local bonus_speed = talent:GetSpecialValueFor("value")
        mine:SetBaseMoveSpeed(mine:GetBaseMoveSpeed() + bonus_speed)
        if mine_modifier then
            mine_modifier:SetRooted(false)
        end
    end
    EmitSoundOn("Hero_Techies.RemoteMine.Plant", mine)
end

function custom_techies_land_mines_old:ProcsMagicStick()
	return true
end