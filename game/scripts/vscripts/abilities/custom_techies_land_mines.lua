custom_techies_land_mines = class({})
LinkLuaModifier("modifier_custom_techies_land_mine", "modifiers/modifier_custom_techies_land_mine", LUA_MODIFIER_MOTION_NONE)

function custom_techies_land_mines:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function custom_techies_land_mines:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    if not caster or not point then return end
    local mine = CreateUnitByName("npc_dota_techies_land_mine_custom", point, true, caster, caster, caster:GetTeamNumber())
    mine:SetControllableByPlayer(caster:GetPlayerID(), true)
    local mine_modifier = mine:AddNewModifier(caster, self, "modifier_custom_techies_land_mine", {})
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

function custom_techies_land_mines:ProcsMagicStick()
	return true
end