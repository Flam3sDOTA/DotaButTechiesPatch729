"use strict";

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

(function() {
    GameEvents.Subscribe("request_detonate_selected", OnRequestDetonateSelected);
})();