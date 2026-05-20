modifier_custom_techies_land_mine_old = class({})

function modifier_custom_techies_land_mine_old:IsHidden() return true end
function modifier_custom_techies_land_mine_old:IsPurgable() return false end
function modifier_custom_techies_land_mine_old:IsDebuff() return false end
function modifier_custom_techies_land_mine_old:GetPriority()
  return MODIFIER_PRIORITY_SUPER_ULTRA + 10000
end

function modifier_custom_techies_land_mine_old:OnCreated(kv)
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
    self.min_plant_distance  = self.ability:GetSpecialValueFor("min_plant_distance")
    self.active             = false
    self.detonation_timer   = 0
    self.visible_to_enemies = false
    self.bRootEnabled = true

    self.parent_entindex = self.parent:GetEntityIndex()

    CustomGameEventManager:Send_ServerToAllClients("mine_planted", {
        entindex  = self.parent_entindex,
        owner_pid = self.caster:GetPlayerOwnerID(),
        team      = self.caster:GetTeamNumber(),
        min_dist  = self.min_plant_distance,
    })

    self:StartIntervalThink(self.activation_delay)
end

function modifier_custom_techies_land_mine_old:OnIntervalThink()
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

    local enemy_in_range = false
    for _, e in pairs(enemies) do
        if e and not e:IsNull() and not e:HasFlyMovementCapability() then
            enemy_in_range = true
            break
        end
    end
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

function modifier_custom_techies_land_mine_old:Explode()
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

    local pre_alive_heroes = {}
    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsRealHero() and enemy:IsAlive() then
            table.insert(pre_alive_heroes, enemy)
        end
    end

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

    local killed_pids = {}
    for _, h in ipairs(pre_alive_heroes) do
        if not h:IsNull() and not h:IsAlive() then
            local pid = h:GetPlayerID()
            if pid and pid >= 0 then
                table.insert(killed_pids, pid)
            end
        end
    end
    if #killed_pids >= 2 and GameRules.SlacksTechies and GameRules.SlacksTechies.RecordMultiKill then
        GameRules.SlacksTechies:RecordMultiKill(killed_pids)
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

function modifier_custom_techies_land_mine_old:OnDestroy()
    if not IsServer() then return end
    if not self.parent_entindex then return end
    CustomGameEventManager:Send_ServerToAllClients("mine_removed", {
        entindex = self.parent_entindex,
    })
end

function modifier_custom_techies_land_mine_old:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION]           = true,
        [MODIFIER_STATE_ROOTED]                      = self.bRootEnabled,
        [MODIFIER_STATE_MAGIC_IMMUNE]                = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_INVISIBLE]                   = not self.visible_to_enemies,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY]         = true,
        [MODIFIER_STATE_DEBUFF_IMMUNE]               = true,
    }
end

function modifier_custom_techies_land_mine_old:SetRooted(bValue)
    self.bRootEnabled = bValue
end

function modifier_custom_techies_land_mine_old:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_AVOID_SPELL,
    }
end

function modifier_custom_techies_land_mine_old:GetAbsoluteNoDamageMagical()  return 1 end
function modifier_custom_techies_land_mine_old:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_custom_techies_land_mine_old:GetAbsoluteNoDamagePure()     return 1 end
function modifier_custom_techies_land_mine_old:GetDisableHealing()           return 1 end
function modifier_custom_techies_land_mine_old:GetModifierAvoidSpell()       return 1 end

function modifier_custom_techies_land_mine_old:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.target == self.parent then
        self.parent:Kill(self.ability, keys.attacker)
    end
end

