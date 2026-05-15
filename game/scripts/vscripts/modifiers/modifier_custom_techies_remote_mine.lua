modifier_custom_techies_remote_mine = class({})

function modifier_custom_techies_remote_mine:IsHidden()  return true  end
function modifier_custom_techies_remote_mine:IsPurgable() return false end
function modifier_custom_techies_remote_mine:IsDebuff() return false end
function modifier_custom_techies_remote_mine:GetPriority()
  return MODIFIER_PRIORITY_SUPER_ULTRA + 10000
end

function modifier_custom_techies_remote_mine:OnCreated()
    if not IsServer() then return end
    
    self.ability    = self:GetAbility()
    self.caster     = self:GetCaster()
    self.parent     = self:GetParent()
    self.detonating = false
    self.faded      = false
    self.bRootEnabled = true

    

    Timers:CreateTimer(self.ability:GetSpecialValueFor("fade_time"), function()
        self.faded = true
    end)
end

function modifier_custom_techies_remote_mine:Detonate()
    if self.detonating then return end
    self.detonating = true
    local parent  = self.parent
    local ability = self.ability
    local caster  = self.caster
    Timers:CreateTimer(ability:GetSpecialValueFor("detonation_delay"), function()
        self:Explode()
    end)
end

function modifier_custom_techies_remote_mine:Explode()
    if not self.parent or self.parent:IsNull() then return end
    if not self.parent:IsAlive() then return end

    local pos    = self.parent:GetAbsOrigin()
    local radius = self.ability:GetSpecialValueFor("radius")
    local damage = self.ability:GetSpecialValueFor("damage")
    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(), pos, nil, radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER, false)

    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() then
            ApplyDamage({
                victim      = enemy,
                attacker    = self.caster,
                ability     = self.ability,
                damage      = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
            })
        end
    end

    self.parent:AddNoDraw()

    local pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf",
        PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
    ParticleManager:SetParticleControl(pfx, 3, pos)
    ParticleManager:ReleaseParticleIndex(pfx)

    EmitSoundOnLocationWithCaster(pos, "Hero_Techies.StickyBomb.Detonate", self.caster)
    self.ability:CreateVisibilityNode(pos, 500, 3.0)
    self.parent:ForceKill(false)
end

function modifier_custom_techies_remote_mine:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION]           = true,
        [MODIFIER_STATE_ROOTED]                      = self.bRootEnabled,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE]                = true,
        [MODIFIER_STATE_INVISIBLE]                   = self.faded,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY]         = true,
        [MODIFIER_STATE_DEBUFF_IMMUNE]               = true,
        [MODIFIER_STATE_UNTARGETABLE]                = true,
    }
end

function modifier_custom_techies_remote_mine:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_AVOID_SPELL,
        MODIFIER_PROPERTY_DODGE_PROJECTILE,
    }
end

function modifier_custom_techies_remote_mine:SetRooted(bValue)
    self.bRootEnabled = bValue
end

function modifier_custom_techies_remote_mine:GetAbsoluteNoDamageMagical()  return 1 end
function modifier_custom_techies_remote_mine:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_custom_techies_remote_mine:GetAbsoluteNoDamagePure()     return 1 end
function modifier_custom_techies_remote_mine:GetDisableHealing()           return 1 end
function modifier_custom_techies_remote_mine:GetModifierAvoidSpell()       return 1 end
function modifier_custom_techies_remote_mine:GetModifierDodgeProjectile()  return 1 end

function modifier_custom_techies_remote_mine:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.target == self.parent then
        self.parent:Kill(self.ability, keys.attacker)
    end
end