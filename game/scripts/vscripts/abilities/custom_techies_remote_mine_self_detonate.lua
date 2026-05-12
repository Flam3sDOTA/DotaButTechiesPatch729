custom_techies_remote_mine_self_detonate = class({})

function custom_techies_remote_mine_self_detonate:OnSpellStart()
    local mine = self:GetCaster()
    local mod  = mine:FindModifierByName("modifier_custom_techies_remote_mine")
    if mod then
        mod:Detonate()
    end
end

function custom_techies_remote_mine_self_detonate:IsStealable()    return false end
function custom_techies_remote_mine_self_detonate:ProcsMagicStick() return false end
