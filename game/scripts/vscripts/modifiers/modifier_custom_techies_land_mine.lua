modifier_custom_techies_land_mine = class({})

function modifier_custom_techies_land_mine:IsHidden() return true end
function modifier_custom_techies_land_mine:IsPurgable() return false end

function modifier_custom_techies_land_mine:OnCreated(kv)
    if not IsServer() then return end

    self.ability  = self:GetAbility()
    self.caster   = self:GetCaster()
    self.parent   = self:GetParent()
    self.exploded = false

    self.radius              = self.ability:GetSpecialValueFor("radius")
    self.activation_delay    = self.ability:GetSpecialValueFor("activation_delay")
    self.detonation_delay    = self.ability:GetSpecialValueFor("detonation_delay")
    self.damage              = self.ability:GetSpecialValueFor("damage")
    self.building_damage_pct = self.ability:GetSpecialValueFor("building_damage_pct")

    self.active             = false
    self.detonation_timer   = 0
    self.visible_to_enemies = false
    self.bRootEnabled = true

    self:StartIntervalThink(self.activation_delay)
end

function modifier_custom_techies_land_mine:OnIntervalThink()
    if not self.active then
        self.active = true
        self:StartIntervalThink(0.1)
        return
    end

    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    local enemy_in_range = #enemies > 0
    if enemy_in_range then
        if not self.visible_to_enemies then
            self.visible_to_enemies = true
            EmitSoundOn("Hero_Techies.RemoteMine.Priming", self.parent)
        end

        self.detonation_timer = self.detonation_timer + 0.1

        if self.detonation_timer >= self.detonation_delay then
            self:Explode()
        end
    else
        if self.visible_to_enemies then
            self.visible_to_enemies = false
            StopSoundOn("Hero_Techies.RemoteMine.Priming", self.parent)
        end
        self.detonation_timer = 0
    end
end

function modifier_custom_techies_land_mine:Explode()
    if self.exploded then return end
    self.exploded = true

    if not self.parent or self.parent:IsNull() then return end
    local pos = self.parent:GetAbsOrigin()

    local enemies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        local applied_damage = self.damage
        if enemy:IsBuilding() then
            applied_damage = applied_damage * (self.building_damage_pct / 100)
        end

        ApplyDamage({
            victim      = enemy,
            attacker    = self.caster,
            damage      = applied_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability     = self.ability,
        })
    end

    local nFXIndex = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf",
        PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(nFXIndex, 0, pos)
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.radius, 1, 1))
    ParticleManager:ReleaseParticleIndex(nFXIndex)

    if not self.caster:IsNull() then
        EmitSoundOnLocationWithCaster(pos, "Hero_Techies.StickyBomb.Detonate", self.caster)
    end

    self.parent:ForceKill(false)
end

function modifier_custom_techies_land_mine:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION]           = true,
        [MODIFIER_STATE_ROOTED]                      = self.bRootEnabled,
        [MODIFIER_STATE_MAGIC_IMMUNE]                = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_INVISIBLE]                   = not self.visible_to_enemies,
    }
end

function modifier_custom_techies_land_mine:SetRooted(bValue)
    self.bRootEnabled = bValue
end

function modifier_custom_techies_land_mine:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_custom_techies_land_mine:GetAbsoluteNoDamageMagical()  return 1 end
function modifier_custom_techies_land_mine:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_custom_techies_land_mine:GetAbsoluteNoDamagePure()     return 1 end

function modifier_custom_techies_land_mine:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.target == self.parent then
        self.parent:Kill(self.ability, keys.attacker)
    end
end
