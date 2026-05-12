modifier_techies_blast_off_stun12 = class({})

--------------------------------------------------------------------------------

function modifier_techies_blast_off_stun12:IsDebuff()
    return true
end

function modifier_techies_blast_off_stun12:IsStunDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_techies_blast_off_stun12:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_techies_blast_off_stun12:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_techies_blast_off_stun12:GetOverrideAnimation( params )
    return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_techies_blast_off_stun12:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_techies_blast_off_stun12:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------