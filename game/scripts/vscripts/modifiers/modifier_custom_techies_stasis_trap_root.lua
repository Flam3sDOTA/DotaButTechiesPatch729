modifier_custom_techies_stasis_trap_root = class({})

function modifier_custom_techies_stasis_trap_root:IsHidden()   return false end
function modifier_custom_techies_stasis_trap_root:IsPurgable()  return true  end

function modifier_custom_techies_stasis_trap_root:CheckState()
    return { [MODIFIER_STATE_ROOTED] = true }
end
