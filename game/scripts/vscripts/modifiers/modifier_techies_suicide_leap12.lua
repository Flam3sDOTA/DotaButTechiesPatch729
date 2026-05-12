modifier_techies_suicide_leap12 = class({})

function modifier_techies_suicide_leap12:IsHidden()     return true  end
function modifier_techies_suicide_leap12:IsPurgable()    return false end
function modifier_techies_suicide_leap12:RemoveOnDeath() return true  end

function modifier_techies_suicide_leap12:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION]                = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end

function modifier_techies_suicide_leap12:OnCreated(event)
    if not IsServer() then return end

    local parent     = self:GetParent()
    local parent_loc = parent:GetAbsOrigin()

    local point = Vector(event.point_x, event.point_y, event.point_z)

    local diff            = point - parent_loc
    self.direction        = Vector(diff.x, diff.y, 0):Normalized()
    self.horizontal_speed = Vector(diff.x, diff.y, 0):Length() / 0.75
    self.jump_duration    = 0.75
    self.jump_max_height  = 290
    self.time_elapsed     = 0
    self.current_height   = 0

    self:StartIntervalThink(0.03)
end

function modifier_techies_suicide_leap12:OnIntervalThink()
    if not IsServer() then return end

    local parent = self:GetParent()
    if not parent or parent:IsNull() or not parent:IsAlive() then
        self:Destroy()
        return
    end

    local dt  = 0.03
    local pos = parent:GetAbsOrigin()

    local new_x = pos.x + self.direction.x * self.horizontal_speed * dt
    local new_y = pos.y + self.direction.y * self.horizontal_speed * dt

    local t = self.time_elapsed / self.jump_duration
    self.current_height = self.current_height + dt * self.jump_max_height * (4 - 8 * t)

    local ground = GetGroundPosition(Vector(new_x, new_y, 0), parent)
    parent:SetAbsOrigin(Vector(new_x, new_y, ground.z + self.current_height))

    self.time_elapsed = self.time_elapsed + dt

    if self.time_elapsed >= self.jump_duration then
        self:Destroy()
    end
end

function modifier_techies_suicide_leap12:OnDestroy()
    if not IsServer() then return end

    local parent  = self:GetParent()
    local ability = self:GetAbility()

    if not parent or parent:IsNull() then return end

    local landing_pos = parent:GetAbsOrigin()
    FindClearSpaceForUnit(parent, landing_pos, false)

    if ability and not ability:IsNull() then
        ability:LandingEffect(landing_pos)
    end
end
