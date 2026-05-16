local cosmetics_data = require("cosmetics_data")

function AssignCosmetics(sID, hero)
  local PlayerInfo = cosmetics_data[sID]
  if not PlayerInfo then return end

  if PlayerInfo.model then
    hero:SetModel(PlayerInfo.model)
    hero:SetOriginalModel(PlayerInfo.model)
    print("[Cosmetics] Model Set")
  end

  if PlayerInfo.particle then
    ParticleManager:CreateParticle(PlayerInfo.particle, PATTACH_ABSORIGIN_FOLLOW, hero)
    print("[Cosmetics] Particle Set")
  end

  if PlayerInfo.material_group then
    hero:SetMaterialGroup(PlayerInfo.material_group)
    print("[Cosmetics] Material Group Set")
  end

  if PlayerInfo.chat_message then
    GameRules:SendCustomMessage(PlayerInfo.chat_message, 0, 0)
    print("[Cosmetics] Chat Message Sent")
  end

  if PlayerInfo.sound then
    if PlayerInfo.sound_global then
      for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:IsValidPlayerID(playerID) then
          local p = PlayerResource:GetPlayer(playerID)
          if p then EmitSoundOnClient(PlayerInfo.sound, p) end
        end
      end
    else
      local owner = hero:GetPlayerOwner()
      if owner then EmitSoundOnClient(PlayerInfo.sound, owner) end
    end
    print("[Cosmetics] Sound Played")
  end
end