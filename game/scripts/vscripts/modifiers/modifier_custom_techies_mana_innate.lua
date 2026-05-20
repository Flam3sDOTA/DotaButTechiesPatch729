modifier_custom_techies_mana_innate = class({})

function modifier_custom_techies_mana_innate:IsHidden()      return true  end
function modifier_custom_techies_mana_innate:IsPurgable()    return false end
function modifier_custom_techies_mana_innate:RemoveOnDeath() return false end

local TAUNT_TEXTS = {
    "gg ez",
    "?",
    "First time?",
    "Imagine dying to Techies in 2026",
    "OSFROG Balanced BTW",
    "Smells like skill issue",
    "0 map awareness",
    "I have reviewed the replay. The decision to walk forward at that moment was poor. The decision to not buy sentries was poorer.",
    "7.29 Techies. We've had issues with 7.29 Techies at previous patches. Some Valve people lobbied to bring him back for 7.41, feeling that he deserved another chance. That was a mistake. 7.29 Techies is an ass, and we won't be seeing him again.",
    "Wash your face",
    "Is this what SUNSfan warned us about?",
    "Average sentry buyer vs average techies victim — you know which one you are",
}

local TAUNT_SOUNDS = {
    "SadViolinKill",
    "RickRoll",
    "soundboard.crybaby",
    "soundboard.easiest_money",
    "soundboard.eughahaha",
    "soundboard.glados.probability_99",
    "soundboard.next_level",
    "soundboard.no_chill",
    "soundboard.oh_my_god_what_oh_oh",
    "soundboard.playing_to_win",
    "soundboard.that_was_questionable",
    "soundboard.ti10eventgame.reward4",
    "soundboard.whats_cooking",
    "stickers.season6.68186278",
}


function modifier_custom_techies_mana_innate:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_DEATH,
    }
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

function modifier_custom_techies_mana_innate:OnDeath(event)
    if not IsServer() then return end
    if event.attacker ~= self:GetParent() then return end
    if not event.unit or event.unit:IsNull() then return end
    if not event.unit:IsRealHero() then return end
    if event.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

    local parent = self:GetParent()
    local pid = parent:GetPlayerOwnerID()
    if pid == -1 then return end

    local now = GameRules:GetGameTime()
    if self.last_taunt and now - self.last_taunt < 3.0 then return end
    self.last_taunt = now

    if RandomInt(1, 2) == 1 then
        local text = TAUNT_TEXTS[RandomInt(1, #TAUNT_TEXTS)]
        Say(PlayerResource:GetPlayer(pid), text, false)
    else
        local sound = TAUNT_SOUNDS[RandomInt(1, #TAUNT_SOUNDS)]
        Timers:CreateTimer(1, function()
            EmitGlobalSound(sound)
        end)
    end
end