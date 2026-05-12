custom_techies_stasis_trap = class({})

LinkLuaModifier("modifier_custom_techies_stasis_trap_deploy", "modifiers/modifier_custom_techies_stasis_trap_deploy", LUA_MODIFIER_MOTION_NONE)

function custom_techies_stasis_trap:GetAOERadius()
    return self:GetSpecialValueFor("stun_radius")
end

function custom_techies_stasis_trap:OnSpellStart()
    local caster = self:GetCaster()
    local point  = self:GetCursorPosition()
    if not caster or not point then return end
    local trap = CreateUnitByName("npc_dota_techies_stasis_trap", point, true, caster, caster, caster:GetTeamNumber())
    trap:SetControllableByPlayer(caster:GetPlayerID(), true)
    local trap_modifier = trap:AddNewModifier(caster, self, "modifier_custom_techies_stasis_trap_deploy", {})
    local talent = caster:FindAbilityByName("special_bonus_unique_techies_25_l")
    if talent and talent:GetLevel() > 0 then
        local bonus_speed = talent:GetSpecialValueFor("value")
        trap:SetBaseMoveSpeed(trap:GetBaseMoveSpeed() + bonus_speed)
        if trap_modifier then
            trap_modifier:SetRooted(false)
        end
    end
    EmitSoundOn("Hero_Techies.StasisTrap.Plant", trap)
end
