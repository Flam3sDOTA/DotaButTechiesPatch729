custom_techies_minefield_sign = class({})

LinkLuaModifier("modifier_custom_techies_minefield_sign", "modifiers/modifier_custom_techies_minefield_sign", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_techies_sign_truesight",  "modifiers/modifier_custom_techies_sign_truesight",  LUA_MODIFIER_MOTION_NONE)

TechiesSign = TechiesSign or {}

function custom_techies_minefield_sign:OnSpellStart()
    local caster = self:GetCaster()
    local point  = self:GetCursorPosition()
    if not caster or not point then return end

    local fountains = Entities:FindAllByClassname("ent_dota_fountain")
    for _, fountain in pairs(fountains) do
        if (fountain:GetAbsOrigin() - point):Length2D() < 1300 then
            EmitSoundOn("General.InvalidTarget_Invulnerable", caster)
            return
        end
    end

    local pid = caster:GetPlayerID()
    if TechiesSign[pid] and not TechiesSign[pid]:IsNull() then
        UTIL_Remove(TechiesSign[pid])
    end

    local sign = CreateUnitByName("npc_dota_techies_custom_sign", point, true, caster, caster, caster:GetTeamNumber())
    sign:SetOwner(caster:GetOwner())
    sign:AddNewModifier(caster, self, "modifier_custom_techies_minefield_sign", {duration = self:GetSpecialValueFor("duration")})
    sign:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})

    TechiesSign[pid] = sign
end
