custom_techies_land_mines_old = class({})
LinkLuaModifier("modifier_custom_techies_land_mine_old", "modifiers/modifier_custom_techies_land_mine_old", LUA_MODIFIER_MOTION_NONE)
SlacksMineList = SlacksMineList or {}

function custom_techies_land_mines_old:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function custom_techies_land_mines_old:CastFilterResultLocation(point)
    local caster = self:GetCaster()
    if not IsServer() then return UF_SUCCESS end

    local min_dist = self:GetSpecialValueFor("min_plant_distance")
    local cpid = caster:GetPlayerID()
    for _, m in pairs(SlacksMineList) do
        if m and not m:IsNull() and m:IsAlive() and m:GetPlayerOwnerID() == cpid then
            if (m:GetAbsOrigin() - point):Length2D() < min_dist then
                return UF_FAIL_CUSTOM
            end
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
    table.insert(SlacksMineList, mine)
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