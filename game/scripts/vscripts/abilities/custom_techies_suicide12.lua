custom_techies_suicide12 = class({})

LinkLuaModifier("modifier_techies_suicide_silence12",  "modifiers/modifier_techies_suicide_silence12",  LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_techies_suicide_leap12",     "modifiers/modifier_techies_suicide_leap12",     LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_techies_blast_off_stun12",   "modifiers/modifier_techies_blast_off_stun12",   LUA_MODIFIER_MOTION_NONE)

function custom_techies_suicide12:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function custom_techies_suicide12:OnSpellStart()
    local caster = self:GetCaster()
    local point  = self:GetCursorPosition()
    if not caster or not point then return end

    caster:EmitSound("Hero_Techies.BlastOff.Cast")
    ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_blast_off_cast.vpcf", PATTACH_ABSORIGIN, caster)
    caster:AddNewModifier(caster, self, "modifier_techies_suicide_leap12", {
        point_x = point.x,
        point_y = point.y,
        point_z = point.z,
    })
end

function custom_techies_suicide12:LandingEffect(landing_pos)
    local caster = self:GetCaster()

    GridNav:DestroyTreesAroundPoint(landing_pos, 150, true)

    local pfx = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_techies/techies_blast_off.vpcf",
        PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, landing_pos)
    ParticleManager:ReleaseParticleIndex(pfx)

    caster:EmitSound("Hero_Techies.Suicide")

    local radius      = self:GetSpecialValueFor("radius")
    local damage      = self:GetSpecialValueFor("damage")
    local silence_dur = self:GetSpecialValueFor("silence_duration")

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), landing_pos, nil, radius,
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
            ApplyDamage({
                victim      = enemy,
                attacker    = caster,
                ability     = self,
                damage      = damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
            })
            enemy:AddNewModifier(caster, self, "modifier_techies_suicide_silence12", {duration = silence_dur})
            if caster and not caster:IsNull() and caster:HasModifier("modifier_item_aghanims_shard") then
                enemy:AddNewModifier(caster, self, "modifier_techies_blast_off_stun12", {duration = self:GetSpecialValueFor("stun_duration")})
            end
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

    if not caster:IsNull() and caster:IsAlive() then
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

function custom_techies_suicide12:ProcsMagicStick()
	return true
end