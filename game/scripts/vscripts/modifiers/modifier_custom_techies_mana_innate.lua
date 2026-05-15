modifier_custom_techies_mana_innate = class({})

function modifier_custom_techies_mana_innate:IsHidden()   return true  end
function modifier_custom_techies_mana_innate:IsPurgable() return false end
function modifier_custom_techies_mana_innate:RemoveOnDeath() return false end

function modifier_custom_techies_mana_innate:DeclareFunctions()
    return { MODIFIER_PROPERTY_MANA_REGEN_CONSTANT }
end

function modifier_custom_techies_mana_innate:GetModifierConstantManaRegen()
    local parent = self:GetParent()
    if not parent or parent:IsNull() then return 0 end
    local ability = self:GetAbility()
    if not ability then return 0 end
    
    local base_pct      = ability:GetSpecialValueFor("base_pct") / 100
    local per_level_pct = ability:GetSpecialValueFor("per_level_pct") / 100
    local level = parent:GetLevel()
    local max_mana = parent:GetMaxMana()
    
    return max_mana * (base_pct + per_level_pct * level)
end