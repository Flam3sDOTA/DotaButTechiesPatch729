"use strict";
HidePickScreen()

function OnRequestDetonateSelected(data) {
    if (data.target_pid !== Players.GetLocalPlayer()) return;
    
    var selection = Players.GetSelectedEntities(Players.GetLocalPlayer());
    
    if (!selection || selection.length === 0) {
        selection = [data.caster_entindex];
    }
    GameEvents.SendCustomGameEventToServer("detonate_selected_mines", {
        entities: selection
    });
}


function HidePickScreen() {
    if (!Game.GameStateIs(DOTA_GameState.DOTA_GAMERULES_STATE_HERO_SELECTION))
    {
        PreGame.style.opacity = "0";
        $.Schedule(0.25, HidePickScreen);
    }
    else
    {
        PreGame.style.opacity = "1";
    }
}

(function() {
    GameEvents.Subscribe("request_detonate_selected", OnRequestDetonateSelected);
})();