modifier_techies_suicide_silence12 = class({})

function modifier_techies_suicide_silence12:IsHidden()  return false end
function modifier_techies_suicide_silence12:IsPurgable() return true  end
function modifier_techies_suicide_silence12:IsDebuff()   return true  end

function modifier_techies_suicide_silence12:CheckState()
    return { [MODIFIER_STATE_SILENCED] = true }
end

function modifier_techies_suicide_silence12:GetEffectName()
    return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_techies_suicide_silence12:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
