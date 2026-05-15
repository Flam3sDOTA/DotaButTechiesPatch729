modifier_custom_techies_minefield_sign = class({})

function modifier_custom_techies_minefield_sign:IsHidden()  return true  end
function modifier_custom_techies_minefield_sign:IsPurgable() return false end
function modifier_custom_techies_minefield_sign:GetPriority()
  return MODIFIER_PRIORITY_SUPER_ULTRA + 10000
end

function modifier_custom_techies_minefield_sign:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION]           = true,
        [MODIFIER_STATE_ROOTED]                      = true,
        [MODIFIER_STATE_MAGIC_IMMUNE]                = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR_FOR_ENEMIES]   = true,
        [MODIFIER_STATE_ATTACK_IMMUNE]               = true,
        [MODIFIER_STATE_INVULNERABLE]                = true,
        [MODIFIER_STATE_CANNOT_TARGET_ENEMIES]       = true,
        [MODIFIER_STATE_CANNOT_TARGET_BUILDINGS]     = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY]         = true,
        [MODIFIER_STATE_UNTARGETABLE]                = true,
    }
end

function modifier_custom_techies_minefield_sign:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    }
end

function modifier_custom_techies_minefield_sign:GetAbsoluteNoDamageMagical()  return 1 end
function modifier_custom_techies_minefield_sign:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_custom_techies_minefield_sign:GetAbsoluteNoDamagePure()     return 1 end

function modifier_custom_techies_minefield_sign:IsAura()
    local caster = self:GetCaster()
    return caster and not caster:IsNull() and caster:HasScepter()
end

function modifier_custom_techies_minefield_sign:GetAuraRadius()       return 125 end
function modifier_custom_techies_minefield_sign:GetAuraSearchTeam()   return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_techies_minefield_sign:GetAuraSearchType()   return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER end
function modifier_custom_techies_minefield_sign:GetAuraSearchFlags()  return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_custom_techies_minefield_sign:GetModifierAura()     return "modifier_custom_techies_sign_truesight" end
