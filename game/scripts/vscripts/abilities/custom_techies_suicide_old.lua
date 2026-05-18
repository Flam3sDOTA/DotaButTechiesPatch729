custom_techies_suicide_old = class({})

LinkLuaModifier("modifier_techies_suicide_respawn_time", "modifiers/modifier_techies_suicide_respawn_time", LUA_MODIFIER_MOTION_NONE)

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
        caster:Kill(self, caster)
        caster:AddItemByName("item_tpscroll")
    end
end

function custom_techies_suicide_old:ProcsMagicStick()
    return true
end