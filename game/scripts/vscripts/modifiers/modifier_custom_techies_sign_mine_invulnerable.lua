modifier_custom_techies_sign_mine_invulnerable = class({})

function modifier_custom_techies_sign_mine_invulnerable:IsHidden()   return true  end
function modifier_custom_techies_sign_mine_invulnerable:IsPurgable()  return false end

function modifier_custom_techies_sign_mine_invulnerable:CheckState()
    if self:GetParent():GetUnitName() == "npc_dota_techies_land_mine_custom" then
        return { [MODIFIER_STATE_INVULNERABLE] = true }
    end
    return {}
end
