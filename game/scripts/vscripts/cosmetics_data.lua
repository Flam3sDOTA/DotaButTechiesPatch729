  return {

    --[[ ============================================================
      TEMPLATE — all possible fields.
      
      [00000000] = { -- steamID3
        model =          "models/...vmdl",   -- changes hero model
        particle =       "particles/...vpcf", -- attaches ambient particle
        material_group = "default",           -- model skin/material ("0","1","5", etc.)
        chat_message =   "#Response_GodGamer", -- shown in chat
        sound =          "stickers.season6.68186278", -- sound event name
        sound_global =   true,                -- true = everyone hears it; omit/false = only that player
      },
    ============================================================ ]]

    [68186278] = { -- SirActionSlacks
      particle =          "particles/fall_2022_emblem_effect_player_base_custom.vpcf",
      chat_message =      "#Response_GodGamer",
      sound =             "stickers.season6.68186278",
      sound_global =      true,
    },

  }