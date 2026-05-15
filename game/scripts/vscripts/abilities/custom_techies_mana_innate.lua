custom_techies_mana_innate = class({})

LinkLuaModifier("modifier_custom_techies_mana_innate", "modifiers/modifier_custom_techies_mana_innate", LUA_MODIFIER_MOTION_NONE)

function custom_techies_mana_innate:GetIntrinsicModifierName()
    return "modifier_custom_techies_mana_innate"
end