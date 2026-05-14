custom_techies_remote_mine_self_detonate = class({})

function custom_techies_remote_mine_self_detonate:OnSpellStart()
    local mine = self:GetCaster()
    local pid  = mine:GetPlayerOwnerID()
    local player = PlayerResource:GetPlayer(pid)
    if not player then 
        return 
    end
    
    CustomGameEventManager:Send_ServerToAllClients(
        "request_detonate_selected",
        { caster_entindex = mine:GetEntityIndex(), target_pid = pid }
    )
end

function custom_techies_remote_mine_self_detonate:IsStealable()    return false end
function custom_techies_remote_mine_self_detonate:ProcsMagicStick() return false end