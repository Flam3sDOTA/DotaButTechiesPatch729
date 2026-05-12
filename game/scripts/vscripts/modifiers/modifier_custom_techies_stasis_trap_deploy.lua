modifier_custom_techies_stasis_trap_deploy = class({})

LinkLuaModifier("modifier_custom_techies_stasis_trap_root", "modifiers/modifier_custom_techies_stasis_trap_root", LUA_MODIFIER_MOTION_NONE)

function modifier_custom_techies_stasis_trap_deploy:IsHidden()   return true  end
function modifier_custom_techies_stasis_trap_deploy:IsPurgable()  return false end

function modifier_custom_techies_stasis_trap_deploy:OnCreated()
    if not IsServer() then return end

    self.ability        = self:GetAbility()
    self.caster         = self:GetCaster()
    self.parent         = self:GetParent()
    self.active         = false
    self.triggered      = false
    self.trigger_radius = self.ability:GetSpecialValueFor("trigger_radius")
    self.stun_radius    = self.ability:GetSpecialValueFor("stun_radius")
    self.root_duration  = self.ability:GetSpecialValueFor("root_duration")
    self.bRootEnabled = true

    self:StartIntervalThink(self.ability:GetSpecialValueFor("activation_delay"))
end

function modifier_custom_techies_stasis_trap_deploy:OnIntervalThink()
    if not self.active then
        self.active = true
        self:StartIntervalThink(0.1)
        return
    end

    if self.triggered then return end
    if not self.parent or self.parent:IsNull() then return end

    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.trigger_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_ANY_ORDER,
        false
    )

    if #enemies > 0 then
        self:Trigger()
    end
end

function modifier_custom_techies_stasis_trap_deploy:Trigger()
    self.triggered = true
    if not self.parent or self.parent:IsNull() then return end

    local pos = self.parent:GetAbsOrigin()

    local nearby_traps = Entities:FindAllByClassname("npc_dota_techies_stasis_trap")
    for _, trap in pairs(nearby_traps) do
        if trap ~= self.parent and not trap:IsNull() and trap:GetTeamNumber() == self.parent:GetTeamNumber() then
            if (trap:GetAbsOrigin() - pos):Length2D() <= 600 then
                trap:ForceKill(false)
            end
        end
    end

    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(), pos, nil, self.stun_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER, false
    )

    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() then
            enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_techies_stasis_trap_root", {duration = self.root_duration})
        end
    end

    local pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf",
        PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, Vector(self.stun_radius, 1, 1))
    ParticleManager:ReleaseParticleIndex(pfx)

    EmitSoundOnLocationWithCaster(pos, "Hero_Techies.ReactiveTazer.Detonate", self.caster)
    self.ability:CreateVisibilityNode(pos, 600, 1.0)

    self.parent:ForceKill(false)
end

function modifier_custom_techies_stasis_trap_deploy:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION]           = true,
        [MODIFIER_STATE_ROOTED]                      = self.bRootEnabled,
        [MODIFIER_STATE_MAGIC_IMMUNE]                = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_INVISIBLE]                   = self.active,
    }
end

function modifier_custom_techies_stasis_trap_deploy:SetRooted(bValue)
    self.bRootEnabled = bValue
end

function modifier_custom_techies_stasis_trap_deploy:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_custom_techies_stasis_trap_deploy:GetAbsoluteNoDamageMagical()  return 1 end
function modifier_custom_techies_stasis_trap_deploy:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_custom_techies_stasis_trap_deploy:GetAbsoluteNoDamagePure()     return 1 end

function modifier_custom_techies_stasis_trap_deploy:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.target == self.parent then
        self.parent:Kill(self.ability, keys.attacker)
    end
end
