modifier_custom_techies_sign_truesight = class({})

function modifier_custom_techies_sign_truesight:IsHidden()   return true  end
function modifier_custom_techies_sign_truesight:IsPurgable()  return false end

local MINE_UNITS = {
    ["npc_dota_techies_land_mine_custom"]   = true,
    ["npc_dota_techies_stasis_trap"]        = true,
    ["npc_dota_techies_custom_remote_mine"] = true,
}

function modifier_custom_techies_sign_truesight:CheckState()
    if MINE_UNITS[self:GetParent():GetUnitName()] then
        return {
            [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
            [MODIFIER_STATE_INVISIBLE]        = true,
        }
    end
    return {}
end
