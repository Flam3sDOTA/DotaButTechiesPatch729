custom_techies_focused_detonate = class({})

function custom_techies_focused_detonate:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function custom_techies_focused_detonate:OnSpellStart()
    local caster = self:GetCaster()
    local point  = self:GetCursorPosition()
    if not caster or not point then return end

    local radius = self:GetSpecialValueFor("radius")

    local allies = FindUnitsInRadius(
        caster:GetTeamNumber(), point, nil, radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER, false)

    for _, ally in pairs(allies) do
        if ally and not ally:IsNull() and ally:HasModifier("modifier_custom_techies_remote_mine") then
            if ally:GetPlayerOwnerID() == caster:GetPlayerID() then
                local mod = ally:FindModifierByName("modifier_custom_techies_remote_mine")
                if mod then
                    mod:Detonate()
                end
            end
        end
    end
end

function custom_techies_focused_detonate:IsStealable()  return false end
function custom_techies_focused_detonate:ProcsMagicStick() return false end
