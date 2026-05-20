custom_techies_suicide_old = class({})

function custom_techies_suicide_old:GetAOERadius()
    return self:GetSpecialValueFor("partial_damage_radius")
end

function custom_techies_suicide_old:OnSpellStart()
    local caster = self:GetCaster()
    if not caster or caster:IsNull() then return end

    local origin = caster:GetAbsOrigin()

    caster:EmitSound("Hero_Techies.Suicide")

    local pfx = ParticleManager:CreateParticle(
        "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf",
        PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, origin)
    ParticleManager:ReleaseParticleIndex(pfx)

    GridNav:DestroyTreesAroundPoint(origin, 500, true)

    local full_radius     = self:GetSpecialValueFor("full_damage_radius")
    local partial_radius  = self:GetSpecialValueFor("partial_damage_radius")
    local full_damage     = self:GetSpecialValueFor("full_damage")
    local partial_damage  = self:GetSpecialValueFor("partial_damage")

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), origin, nil, partial_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    local pre_alive_heroes = {}
    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsRealHero() and enemy:IsAlive() then
            table.insert(pre_alive_heroes, enemy)
        end
    end

    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() then
            local dist = (enemy:GetAbsOrigin() - origin):Length2D()
            local damage = partial_damage
            if dist <= full_radius then
                damage = full_damage
            end
            ApplyDamage({
                victim      = enemy,
                attacker    = caster,
                ability     = self,
                damage      = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
            })
        end
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

    if caster and not caster:IsNull() and caster:IsAlive() then
        caster:RemoveModifierByName("modifier_dazzle_shallow_grave")
        caster:RemoveModifierByName("modifier_item_aeon_disk_buff")
        caster:RemoveModifierByName("modifier_oracle_false_promise")
        local self_damage = caster:GetMaxHealth() * (self:GetSpecialValueFor("hp_cost_pct") / 100)
        ApplyDamage({
            victim       = caster,
            attacker     = caster,
            ability      = self,
            damage       = self_damage,
            damage_type  = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        })
        if caster:GetHealth() <= 0 then
            caster:AddItemByName("item_tpscroll")
            caster:Kill(self, caster)
        end
    end
end

function custom_techies_suicide_old:ProcsMagicStick()
    return true
end