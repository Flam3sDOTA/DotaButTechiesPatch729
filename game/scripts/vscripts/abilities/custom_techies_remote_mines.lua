custom_techies_remote_mines = class({})

LinkLuaModifier("modifier_custom_techies_remote_mine", "modifiers/modifier_custom_techies_remote_mine", LUA_MODIFIER_MOTION_NONE)

function custom_techies_remote_mines:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function custom_techies_remote_mines:OnSpellStart()
    local caster = self:GetCaster()
    local point  = self:GetCursorPosition()
    if not caster or not point then return end
    
    local mine = CreateUnitByName("npc_dota_techies_custom_remote_mine", point, true, caster, caster, caster:GetTeamNumber())
    mine:SetControllableByPlayer(caster:GetPlayerID(), true)
    ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_remote_mine_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, mine)
    local remote_modifier = mine:AddNewModifier(caster, self, "modifier_custom_techies_remote_mine", {})
    mine:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
    local talent = caster:FindAbilityByName("special_bonus_unique_techies_25_l")
    if talent and talent:GetLevel() > 0 then
        local bonus_speed = talent:GetSpecialValueFor("value")
        mine:SetBaseMoveSpeed(mine:GetBaseMoveSpeed() + bonus_speed)
        if remote_modifier then
            remote_modifier:SetRooted(false)
        end
    end
    caster:EmitSound("Hero_Techies.StickyBomb.Plant")
end

function custom_techies_remote_mines:OnUpgrade()
    local focused = self:GetCaster():FindAbilityByName("custom_techies_focused_detonate")
    if focused and focused:GetLevel() < 1 then
        focused:SetLevel(1)
    end
end

function custom_techies_remote_mines:GetAssociatedSecondaryAbilities()
    return "custom_techies_focused_detonate"
end